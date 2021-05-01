function(input, output, session) { 
  
  # #dados
  # dados_deputado<-reactive({ 
  #   
  #   camara3%>%
  #     filter(congressperson_name==input$parl)
  #   
  # })
  
  # valido <- reactive({
  #   dados_deputado() %>% 
  #     group_by(subquota_description) %>% 
  #     count() %>% 
  #     filter(n>50) %>% 
  #     ungroup() %>% 
  #     select(subquota_description) %>%
  #     pull()
  #   
  # })
  # 
  # #atualizando subquotas validas
  # observe(
  #   
  #   
  #   updateSelectInput(
  #     session = getDefaultReactiveDomain(),
  #     "sub",
  #     label = NULL,
  #     choices =valido(),
  #     selected="Combustíveis E Lubrificantes"
  #   )
  # )
  
  
  
  
  
  # output$ecdf <- renderPlotly({
  #   ggplotly(tooltip = "text",
  #     dados_deputado() %>%
  #       arrange(corrigido) %>% 
  #       filter(subquota_description == input$sub,validade=="valido") %>%
  #       ggplot(aes(x=corrigido,colour=label,group=cnpj_cpf,
  #         text=sprintf("Empresa: %s<br>Cnpj: %s<br>Label: %s", fornecedor,cnpj_cpf,label)))+
  #       stat_ecdf()+
  #       theme()
  #   )
  #   
  # })
  
  
  
  
  
}