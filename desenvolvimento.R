library(ggplot2)
library(plotly)
library(tidyverse)

options(scipen = 999)

#calcula o número de produtos vendidos por cada vendedor
n_produtos_vendidos <-  marketplace %>%
  group_by(seller_id) %>% 
  count() %>% 
  select(seller_id,n) %>% 
  arrange(desc(n)) 

#Estimando a densidade do número de ítens vendidos pelas lojas do marketplace

ggplot(n_produtos_vendidos,aes(n))+
  geom_density()


# calcula quanto cada vendedor arrecadou ao todo.  

total_vendedor <- marketplace %>% 
  group_by(seller_id) %>% 
  summarise(total=sum(price,na.rm = T)) %>% 
  arrange(desc(total))

summary(total_vendedor)

ggplot(total_vendedor,aes(total))+
  geom_density()

# Dia em que a venda foi efetuada
marketplace$data_venda <- as.Date(marketplace$order_purchase_timestamp)

# volume de vendas por dia

vendas_dia <- marketplace %>% 
  group_by(data_venda) %>% 
  count()

ggplotly(tooltip=c("data_venda","n","text"),
  ggplot(vendas_dia,aes(x=data_venda,y=n))+
  geom_line()+
  geom_hline(aes(text=sprintf("Volume médio: %s", round(mean(vendas_dia$n)),2),yintercept=mean(vendas_dia$n)),colour="red",size=0.3)+
  labs(x="Dia",y="Volume de vendas",title="Volume de vendas diárias")
    )


total_diario <-  marketplace %>% 
  group_by(data_venda) %>% 
  summarise(total=sum(price,na.rm = T))

ggplotly(tooltip=c("data_venda","total","text"),
  ggplot(total_diario,aes(x=data_venda,y=total))+
    geom_line()+
    geom_hline(aes(text=sprintf("Valor médio: %s", round(mean(total),2)),
    yintercept=round(mean(total),2)),colour="red",size=0.3)+
    labs(x="Dia",y="Arrecadação diária",title="Arrecadação diária")
)




library(foreign)
library(leaflet)
library(rgdal)
library(abjutils)
#Calculando totais para estados

totais_geo <- marketplace %>% 
  group_by(customer_state) %>% 
  summarise(total=sum(price,na.rm = T)) %>% 
  left_join(.,marketplace %>% 
      group_by(customer_state) %>% 
      count(),by = c("customer_state"))

#carregando shape file
ibge <- read.dbf("geo_data\\BR_UF_2020.dbf",as.is = T)

#ajustando encoding
Encoding(ibge$NM_UF) <-"UTF-8"

totais_geo <- merge(ibge,totais_geo,by.x = "SIGLA_UF", by.y = "customer_state")




s <- readOGR("geo_data\\.", "BR_UF_2020", stringsAsFactors=FALSE, encoding="UTF-8")

Encoding(s$NM_UF) <-"UTF-8"

mapa_brasil <- merge(s,totais_geo, by.x = "CD_UF", by.y = "CD_UF")

m <- leaflet(mapa_brasil) 
# %>%
#   setView(-96, 37.8, 4)
bins <- seq(log(min(mapa_brasil$total)),log(max(mapa_brasil$total)),length.out = 9)


#paleta para as cores
pal <- colorBin("YlOrRd", domain = log(totais_geo$total), bins = bins)

#paleta para legendas
pal2 <- colorBin("YlOrRd", domain = totais_geo$total, bins = round(exp(bins)))

labels <- sprintf(
  "<strong>%s</strong><br/>R$ %s",
  mapa_brasil$NM_UF.x, formatC(mapa_brasil$total,big.mark = ".",decimal.mark = ",",digits = 2,format='f')
) %>% lapply(htmltools::HTML)

m %>% addPolygons(
  fillColor = ~pal(log(mapa_brasil$total)),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE
  ),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"
  )
)%>% addLegend(pal = pal2, values = ~n, opacity = 0.7, title = NULL,
  position = "bottomright")


#Clusters estado de São Paulo



sp <- read.dbf("geo_data\\SP_Municipios_2020.dbf",as.is = T)

#ajustando encoding
Encoding(sp$NM_MUN) <-"UTF-8"

sp$NM_MUN_TR <- rm_accent(tolower(sp$NM_MUN))

totais_geo <- merge(sp,dados_geo,by.x = "NM_MUN_TR", by.y = "customer_city")

rm(list=ls()[-c(5,1)])

pop_up <- sprintf("<strong>Tipo de produto: %s</strong><br/>R$ %s",
 totais_geo$product_category_name, formatC(totais_geo$price,big.mark = ".",decimal.mark = ",",digits = 2,format='f'))

leaflet(totais_geo) %>% 
  addTiles() %>% 
  addMarkers(lng = ~totais_geo$geolocation_lng,lat = ~totais_geo$geolocation_lat,
  clusterOptions = markerClusterOptions(),
  popup = pop_up
    
) %>% htmlwidgets::saveWidget( "mapa_sp.html", 
  selfcontained = TRUE)




#Círculos


totais_geo_raio <- totais_geo %>% 
  group_by(customer_zip_code_prefix) %>% 
  summarise(avg_lat=mean(geolocation_lat,na.rm = T),avg_lng=mean(geolocation_lng,na.rm = T),raio=n(),total=sum(price,na.rm = T)) %>% 
  ungroup() %>%
  left_join(.,totais_geo,by = "customer_zip_code_prefix") %>% 
  mutate(l_raio=sqrt(raio))
  
head(totais_geo_raio) %>% view()

pop_up <- sprintf("<strong>Número de pedidos: %s</strong><br/>R$ %s",
  totais_geo_raio$raio, formatC(totais_geo_raio$total,big.mark = ".",decimal.mark = ",",digits = 2,format='f'))


leaflet(totais_geo_raio) %>%
  addTiles() %>%
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addCircles(lat=~totais_geo_raio$avg_lat ,lng =~totais_geo_raio$avg_lng, radius=totais_geo_raio$l_raio, layerId=~customer_zip_code_prefix,
  stroke=F, fillOpacity=0.4,
    popup =sprintf("<strong>Número de pedidos: %s</strong><br/>R$ %s",
    totais_geo_raio$raio, formatC(totais_geo_raio$total,big.mark = ".",decimal.mark = ",",digits = 2,format='f'))) %>%
  htmlwidgets::saveWidget( "mapa_sp_circles_popup.html", 
    selfcontained = TRUE)  
  beepr::beep(5)

# %>%
#   addLegend("bottomleft", values=colorData, title=colorBy,
#     layerId="colorLegend")


