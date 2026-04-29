#!/usr/bin/env Rscript

library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

ui <- fluidPage(
    titlePanel("Exploració del conjunt de dades iris"),
    sidebarLayout(
        sidebarPanel(
            selectInput("x_var", "Variable a l'eix X:",
                choices = names(iris)[sapply(iris, is.numeric)],
                selected = "Sepal.Length"
            ),
            selectInput("y_var", "Variable a l'eix Y:",
                choices = names(iris)[sapply(iris, is.numeric)],
                selected = "Sepal.Width"
            ),
            selectInput("species_filter", "Filtrar per espècie:",
                choices = c(
                    "Totes les observacions" = "all",
                    "Setosa" = "setosa",
                    "Versicolor" = "versicolor",
                    "Virginica" = "virginica"
                ),
                selected = "all"
            ),
            checkboxInput(
                "show_lm", "Mostrar línia de regressió",
                value = FALSE
            ),
            downloadButton("download_data", "Descarregar dades filtrades")
        ),
        mainPanel(
            plotOutput("scatter_plot"),
            verbatimTextOutput("data_summary"),
            DTOutput("data_table")
        )
    )
)
server <- function(input, output) {
    filtered_data <- reactive({
        if (input$species_filter == "all") {
            iris
        } else {
            iris %>% filter(Species == input$species_filter)
        }
    })
    output$scatter_plot <- renderPlot({
        ggplot(
            filtered_data(),
            aes_string(x = input$x_var, y = input$y_var, color = "Species")
        ) +
            geom_point() +
            labs(title = paste(
                "Diagrama de dispersió:", input$x_var, "vs", input$y_var
            )) +
            theme_minimal() +
            if (input$show_lm) geom_smooth(method = "lm", se = FALSE)
    })
    output$data_summary <- renderPrint({
        summary(filtered_data())
    })
    output$data_table <- renderDT({
        datatable(filtered_data())
    })
    output$download_data <- downloadHandler(
        filename = function() {
            paste("iris_filtrat_", Sys.Date(), ".csv", sep = "")
        },
        content = function(file) {
            write.csv(filtered_data(), file, row.names = FALSE)
        }
    )
}
shinyApp(ui = ui, server = server)
