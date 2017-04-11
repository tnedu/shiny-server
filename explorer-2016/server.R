## District Data Explorer
# server.R

shinyServer(function(input, output, session) {

    # Filter data based on selected year and highlight selected district
    filtered <- reactive({

        temp <- ach_profile %>%
            filter(Year == input$year) %>%
            mutate(Selected = 1)

        if (input$highlight != "") {
            mutate(temp, Selected = ifelse(District == input$highlight, 1, 0.3))
        } else {
            return(temp)
        }

    })

    output$scatter <- renderRbokeh({

        color_palette <- switch(input$color,
            "Accountability Status 2015" = c("#1f77b4", "#d62728", "#ff7f0e", "#2ca02c", "#7f7f7f"),
            "Region" = c("#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9476bd", "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22"),
            "TVAAS Literacy" = ,
            "TVAAS Numeracy" = ,
            "TVAAS Science" = ,
            "TVAAS Social Studies" = ,
            "TVAAS Composite" = c("#d62728", "#ff9896", "#98df8a", "#aec7e8", "#1f77b4", "#7f7f7f"),
            "#1f77b4"
        )

        if (input$color == "") {
            tooltip_content <- c("District", input$char, input$outcome)
        } else {
            tooltip_content <- c("District", input$char, input$outcome, input$color)
        }

        p <- figure(data = filtered(), padding_factor = 0.04,
                xlab = names(chars[chars == input$char]),
                ylab = names(outcomes[outcomes == input$outcome]),
                toolbar_location = "above", legend_location = NULL) %>%
            ly_points(x = input$char, y = input$outcome, alpha = Selected,
                color = input$color, hover = tooltip_content) %>%
            set_palette(discrete_color = pal_color(color_palette))

        if (input$char == "Enrollment") {
            x_axis(p, log = TRUE)
        } else {
            return(p)
        }

    })

    output$downloadData <- downloadHandler(
        filename = "achievement_profile_data_2015_2016.csv",
        content = function(file) {
            write_csv(ach_profile, file, na = "")
        }
    )
})
