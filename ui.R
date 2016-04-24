require(shiny)
require(shinydashboard)

shinyUI(
        dashboardPage(
                dashboardHeader(title = "Survey Sample Calculator", 
                                titleWidth = 350),
                dashboardSidebar(width = 350,
                                 sidebarMenu(
                                        menuItem("Calculator Inputs", tabName = "calculatorinputs"),
                                                 sliderInput("conflevel", "Confidence Level (%)",  
                                                             min = 90, max = 99.9, value = 95, step  = 0.5),
                                                 sliderInput("me", "Margin of Error (%)",  
                                                             min = 0.01, max = 10, value = 5, step  = 0.1),
                                                 sliderInput("expprev", "Expected Prevalence (%)",  
                                                             min = 0, max = 100, value = 50, step  = 0.5),
                                                 textInput("pop", "Population Size", value = 10000
                                                 ),
                                        menuItem("Instructions", tabName = "instructions"),
                                        menuItem("Formula", tabName = "formula"),
                                        menuItem("References", tabName = "references")
                                        )

                                ),
                dashboardBody(
                        tabItems(
                                tabItem("calculatorinputs",
                                        fluidRow(
                                                valueBoxOutput(width = 2,
                                                               "confidenceintervalBox"),
                                                valueBoxOutput(width = 2,
                                                               "marginoferrorBox"),
                                                valueBoxOutput(width = 2,
                                                               "expectedprevalenceBox"),
                                                valueBoxOutput(width = 2,
                                                               "populationBox"),
                                                valueBoxOutput(width = 4,
                                                               "samplesizeBox")
                                                 ),
                                        fluidRow(
                                                box(plotOutput("distsamplesizeprevme")),
                                                box(plotOutput("distsamplesizeprevcl"))
                                                )
                                        ),
                                tabItem("instructions",
                                        fluidRow(
                                                box(
                                                        h2("Input panel"), 
                                                        br(),
                                                        h4("It has four widgets for input the parameters required for the calculations:"),
                                                        br(),
                                                        h3("Confidence Level slider"),
                                                        h4("Adjust the confidence level required for estimating the sample size. It is the amount of certaint of the estimation. It is usually set to 95%, i.e, a Type I error rate of 5%. The slider let you adjust the confidence level from 90% to 99.9%."),
                                                        h4("The default value is 95%."),
                                                        h3("Margin of Error slider"),
                                                        h4("This slider adjust the margin of error or precision of the estimate. The larger the margin of error you can tolerate, the smaller is the sample size. The slider let you adjust the margin of error from 0.01% to 10%."),
                                                        h4("The default value is 5%."),
                                                        h3("Expected Prevalence slider"),
                                                        h4("In this slider you can set the expected prevalence. It let you adjust the prevalence from 0% to 100%."),
                                                        h4("The default value is 50%, which results in the highest sample size estimate (See the graphics)."),
                                                        h3("Population"),
                                                        h4("In this box you can set the size of the population from which you are wihdrawing a sample. It is important for correcting the estimated sample for small populations (See the Formula tab)."),
                                                        h4("The default value is 10000 individuals."),
                                                        br(),
                                                        h2("Results panel"), 
                                                        br(),
                                                        h3("Inputs"),
                                                        h4("It has four blue boxes highlighting the input values."),
                                                        br(),
                                                        h3("Sample Size"),
                                                        h4("A green box shows the estimated sample size for the input parameters."),
                                                        br(),
                                                        h3("Effect of Confidence Interval and Prevalance on Sample Size"),
                                                        h4("This graphic shows the effect of Confidence Interval and Prevalance on Sample Size. It plots the estimate sample size for three common confidence levels, 90% (black), 95% (green) and 99% (blue), and prevalences from 0% to 100%, by 10%. The estimate sample size for the your input parameters is also plotted in red."),
                                                        br(),
                                                        h3("Effect of Margin of Error and Prevalance on Sample Size"),
                                                        h4("This graphic shows the effect of Margin of Error and Prevalance on Sample Size. It plots the estimate sample size for three common margins of error, 10% (black), 5% (green) and 1% (blue), and prevalences from 0% to 100%, by 10%. The estimate sample size for the your input parameters is also plotted in red."),
                                                        br(),
                                                        h2("Formula Tab"),
                                                        h4("It shows the formulae used for estimating the sample size."),
                                                        br(),
                                                        h2("References Tab"),
                                                        h4("It shows the reference used for the calculations."),
                                                        
                                                        width = 12, status = "info", solidHeader = TRUE,
                                                        title = "Instructions"
                                                )
                                        )
                                        ),
                                tabItem("formula",
                                        fluidRow(withMathJax(),
                                                box(
                                                        h4("The survey sample is estimated based on the following formula: "),
                                                        br(),
                                                        h1("$$n = \\frac{Z^2p(1-p)}{L^2}$$"),
                                                        br(),
                                                        h4("where:"),
                                                        br(),
                                                        h4("n = the calculated survey sample size;"),
                                                        h4("Z = the Z value required for the especified confidence;"),
                                                        h4("p = the expected prevalence;"),
                                                        h4("L = the margin of error, or precision, of the estimated sample size."),
                                                        br(),
                                                        h4("If the population is small, the Finite Population Correction is used based on the following formula:"),
                                                        br(),
                                                        h1("$$n_{corrected} = \\frac{1}{\\frac{1}{n} + \\frac{1}{pop}}$$"),
                                                        br(),
                                                        h4("where:"),
                                                        br(),
                                                        h4("n = the calculated survey sample size;"),
                                                        h4("pop = the population size."),
                                                        br(),
                                                        h4("The Finite Population Correction is applied automatically if the estimated sample size is equal or greater then 10% of the population."),
                                                        width = 12, status = "info", solidHeader = TRUE,
                                                        title = "Formula")
                                                )
                                        ),
                                tabItem("references",
                                        fluidRow(
                                                box(
                                                        h3("DOHOO, I., MARTIN, W., STRYHN, H. 2003. Veterinary Epidemiologic Research. AVC Inc., p. 41."),
                                                        width = 12, status = "info", solidHeader = TRUE,
                                                        title = "References")
                                        )
                                )

                                )
                                
                        )
                        
                )
        )

