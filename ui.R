# Página
dashboardPage(
  dashboardHeader(
    title = "Marketplace analytics",
    titleWidth = 350
  ),
  
  #Painel lateral  
  dashboardSidebar(
    width = 350,
    sidebarMenu(
      
      menuItem("Indicadores", tabName = "ind", icon = icon("chart-pie",lib = "font-awesome")),
      menuItem("Geográfico", tabName = "gg", icon = icon("globe-americas",lib = "font-awesome"))
      
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "ind",
        
        fluidRow(
          
          # box(width = 12,height = 100,status = "warning", title = "",
          #   background = "light-blue",
          #   selectInput("parl",label = NULL, choices =unique(as.character(camara3$congressperson_name)),selected=sample(unique(camara$congressperson_name),size = 1))),
          # 
          # box(width = 12,height = 100,status = "warning", title = "",
          #   background = "light-blue",
          #   selectInput("sub",label = NULL, choices =unique(as.character(camara3$subquota_description)),selected=sample(unique(camara$subquota_description),size = 1))),
          # 
          # box(status = "warning",title="Unique Users per Game",width = 12,
          #   plotlyOutput("ecdf"))
          
          
          
          #     valueBoxOutput("games_analyzed",width = 6),
          #     valueBoxOutput("unique_users",width = 6),
          #     box(status = "warning",title="Unique Users per Game",width = 12,
          #         plotlyOutput("players_game")),
          #     box(status = "warning",title="Unique Users per Product",width = 12,
          #         plotlyOutput("product_tot")),
          #     box(status = "warning",title="Unique Users per State",width = 12,
          #         leafletOutput("allgamesmap"))
          #     
          #     
          #     
          #   )
          # ),
          # tabItem(
          #   tabName = "gm",
          #   
          #   fluidRow(
          #     box(width = 12,height = 100,status = "warning", title ="Select the game",
          #         background ="light-blue",
          #         
          #         selectInput("Game",label = NULL, choices =complete %>% select(Game) %>% unique %>% pull)
          #         
          #     ),
          #     
          #     valueBoxOutput("rounds"),
          #     valueBoxOutput("registered"),
          #     valueBoxOutput("games_played"),
          #     box(status = "warning",title="Unique Users per Product",width = 12,
          #         plotlyOutput("product")),
          #     
          #     uiOutput("players_"),
          #     
          #     box(status = "warning",title="Accounts created per hour",width = 12,
          #         plotlyOutput("hour")),
          #     fluidRow( uiOutput("map")),
          #     box(status = "warning",title="Register and play",width = 12,
          #         plotlyOutput("register_and_play")),
          #     
          #     
          #     uiOutput("returning"),
          #     uiOutput("round_n")
          
          
          
        )
      ),
      tabItem(
        tabName = "gg",
        
        fluidRow(
          
          # box(width = 12,height = 100,status = "warning", title ="Select User ID",
          #   background ="light-blue",
          #   selectizeInput("user",label = NULL, choices =NULL)
          # ),
          # valueBoxOutput("username",width = 6),
          # valueBoxOutput("created",width = 6),
          # uiOutput("ibox")
        ),
      )
    )
  )
)
