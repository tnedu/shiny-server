## District Data Explorer
# ui.R

shinyUI(navbarPage(title = "Data Explorer", theme = "doe-style.css",

    tabPanel("District",
        fluidRow(
            column(3, offset = 1,
                strong(p("This tool allows users to explore relationships between
                    district characteristics and outcomes for Tennessee school districts.")),
                p("Use the dropdowns below to select a district characteristic
                    and an outcome to plot."),
                br(),
                selectInput(inputId = "year", label = "School Year",
                    choices = c("2015-16" = 2016, "2014-15" = 2015)),
                selectInput(inputId = "char", label = "Select a District Characteristic:",
                    choices = chars, selected = "ED"),
                selectInput(inputId = "outcome", label = "Select an Outcome:",
                    choices = outcomes, selected = "Algebra I"),
                selectInput(inputId = "color", label = "Color Points by:",
                    choices = c("", color_by)),
                selectInput(inputId = "highlight", label = "Highlight a District:",
                    choices = c("", sort(unique(ach_profile$District)[-1]))),
                br(),
                downloadLink('downloadData', 'Click here'), "to download the data for this tool."
            ),
            column(7,
                rbokehOutput("scatter", height = "650px")
            )
        ),
        fluidRow(
            column(10, offset = 1,
                hr(),
                p("Built in", tags$a(href = "http://shiny.rstudio.com/", "Shiny"), "for the Tennessee Deparment of Education."),
                br(),
                br()
            )
        )
    )
))
