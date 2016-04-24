require(shiny)
require(shinydashboard)
require(dplyr)
require(reshape2)
require(ggplot2)

surveysamplesize <- function(z = 0.975, p = 0.5, c = 0.05, pop = 20000) {
                                samplesize1 <- ceiling(
                                        (((qnorm(z)^2)*p*(1-p)) / c^2)
                                )
                                ifelse( samplesize1 < (0.1 * pop),
                                        samplesize1,
                                        ceiling(1 / ((1 / samplesize1) + (1/pop)))
                                )
                        }


simp <- seq(0,1, 0.1)

c10 <- 0.1
c5 <- 0.05
c1 <- 0.01
simc <- c(c10, c5, c1)

simnsize <- matrix(nrow = length(simc), ncol = length(simp))

z90 <- 0.95
z95 <- 0.975
z99 <- 0.995
simz <- c(z90, z95, z99)

simnsizez <- matrix(nrow = length(simz), ncol = length(simp))

simcolor <- c("black", "green4", "blue4")

shinyServer(
        function(input, output, session){
                output$confidenceintervalBox <- renderValueBox({
                        valueBox(
                                input$conflevel, 
                                "Confidence Level",
                                icon = icon("percent"),
                                color = "blue"
                        )
                })
                output$marginoferrorBox <- renderValueBox({
                        valueBox(
                                input$me, 
                                "Margin of Error      ", 
                                icon = icon("percent"),
                                color = "blue"
                        )
                })
                output$expectedprevalenceBox <- renderValueBox({
                        valueBox(
                                input$expprev,
                                "Expected Prevalence", 
                                icon = icon("percent"),
                                color = "blue"
                        )
                })
                output$populationBox <- renderValueBox({
                        valueBox(
                                input$pop,
                                "Population            ", 
                                icon = icon("hashtag"),
                                color = "blue"
                        )
                })
                output$samplesizeBox <- renderValueBox({
                        valueBox(
                                surveysamplesize(z = 1 - ((1 - (input$conflevel) / 100)/2),
                                                 p = input$expprev / 100,
                                                 c = input$me / 100,
                                                 pop = as.numeric(input$pop)),
                                "Sample Size               ", 
                                icon = icon("calculator"),
                                color = "green"
                        )
                })
                
                output$distsamplesizeprevme <- renderPlot({
                        
                        sss <-surveysamplesize(z = 1 - ((1 - (input$conflevel) / 100)/2),
                                               p = input$expprev / 100,
                                               c = input$me / 100,
                                               pop = as.numeric(input$pop))

                        
                        for(i in 1:length(simp)){
                                for(j in 1:length(simz)){
                                        simnsizez[j, i] <- surveysamplesize(z = simz[j],
                                                                            p = simp[i], 
                                                                            c = input$me / 100,
                                                                            pop = as.numeric(input$pop))
                                }
                        }
                        
                        simnsizez <- as.data.frame(simnsizez)
                        simnsizez <- cbind(simnsizez, simz)
                        simnsizez2 <- melt(simnsizez, id.vars = "simz")
                        simnsizez3 <- transmute(simnsizez2, simz = simz, variable = rep(simp, each = 3), value = value)

                         
                        plot(simnsizez3$variable, simnsizez3$value, 
                             type = "n", 
                             axes = FALSE, 
                             ann = FALSE,
                             ylim = c(min(simnsizez),
                                      max(pretty(c(min(simnsizez),
                                                   ifelse(max(simnsizez) < sss, sss, max(simnsizez))),
                                                 10)))
                        )
                        for(i in seq_along(simz)){
                                simnsizez3 %>% 
                                        filter(simz == simz[i]) -> k
                                points(k$variable, k$value, 
                                       pch = 19, col = simcolor[i], cex = 1.2)
                        }
                        for(i in seq_along(simz)){
                                simnsizez3 %>% 
                                        filter(simz == simz[i]) -> k
                                lines(k$variable, k$value, 
                                      lwd = 2, col = simcolor[i])
                        }
                        points(input$expprev / 100, sss, pch = 19, cex = 1.5, col = "red")
                        title(main = "Effects of Confidence Interval and Prevalence",  font.main = 2, 
                              cex.main = 1.4, col.main = c("navyblue"), #title.adj = 0.5,
                              xlab = "Prevalence",  font.lab = 2, cex.lab = 1.5,col.lab = c("blue"),
                              ylab = "Sample Size",  font.lab = 2, cex.lab = 1.5,col.lab = c("blue"))
                        axis(1, at = seq(0, 1, 0.1), 
                             label = seq(0, 100, 10),
                             font.axis = 2)
                        axis(2, at = pretty(c(min(simnsizez),
                                              ifelse(max(simnsizez) < sss, sss, max(simnsizez))),
                                            10),
                             label =pretty(c(min(simnsizez),
                                             ifelse(max(simnsizez) < sss, sss, max(simnsizez))),
                                           10),
                             font.axis = 2)
                        legend("topright",
                               title = "Confidence Level",
                               title.adj = -0.2,
                               bty="n",  
                               legend = c("90 %", "95 %","99 %", NA, "Calculated\nSample Size"),
                               col = c(simcolor, NA, "red"),
                               pch = c(rep(19,3), -1, 19),
                               y.intersp = 0.25,
                               cex = 0.7
                        )
                        
                        
                output$distsamplesizeprevcl <- renderPlot({
                        
                        sss <-surveysamplesize(z = 1 - ((1 - (input$conflevel) / 100)/2),
                                           p = input$expprev / 100,
                                           c = input$me / 100,
                                           pop = as.numeric(input$pop))

                        for(i in 1:length(simp)){
                                for(j in 1:length(simc)){
                                        simnsize[j, i] <- surveysamplesize(z = 1 - ((1 - (input$conflevel) / 100)/2), 
                                                                           p = simp[i], 
                                                                           c = simc[j], 
                                                                           pop = as.numeric(input$pop))
                                }
                        }
                        
                        simnsize <- as.data.frame(simnsize)
                        simnsize <- cbind(simnsize, simc)
                        
                        simnsize2 <- melt(simnsize, id.vars = "simc")
                        simnsize3 <- transmute(simnsize2, simc = simc, variable = rep(simp, each = 3), value = value)
                        
                        plot(simnsize3$variable, simnsize3$value, 
                             type = "n", 
                             axes = FALSE, 
                             ann = FALSE,
                             ylim = c(min(simnsize),
                                      max(pretty(c(min(simnsize),
                                                   ifelse(max(simnsize) < sss, sss, max(simnsize))),
                                                 10)))
                        )
                        for(i in seq_along(simc)){
                                simnsize3 %>% 
                                        filter(simc == simc[i]) -> k
                                points(k$variable, k$value, 
                                       pch = 19, col = simcolor[i], cex = 1.2)
                        }
                        for(i in seq_along(simc)){
                                simnsize3 %>% 
                                        filter(simc == simc[i]) -> k
                                lines(k$variable, k$value, 
                                      lwd = 2, col = simcolor[i])
                        }
                        points(input$expprev / 100, sss, pch = 19, cex = 1.5, col = "red")
                        title(main = "Effects of Margin of Error and Prevalence",  font.main = 2, 
                              cex.main = 1.4, col.main = c("navyblue"),# title.adj = 0.5,
                              xlab = "Prevalence",  font.lab = 2, cex.lab = 1.5,col.lab = c("blue"),
                              ylab = "Sample Size",  font.lab = 2, cex.lab = 1.5,col.lab = c("blue"))
                        axis(1, at = seq(0, 1, 0.1), 
                             label = seq(0, 100, 10),
                             font.axis = 2)
                        axis(2, at = pretty(c(min(simnsize),
                                              ifelse(max(simnsize) < sss, sss, max(simnsize))),
                                            10),
                             label =pretty(c(min(simnsize),
                                             ifelse(max(simnsize) < sss, sss, max(simnsize))),
                                           10),
                             font.axis = 2)
                        legend("topright",
                               title = "Margin of Error",
                               title.adj = -0.2,
                               bty="n",  
                               legend = c("10 %", "5 %","1 %", NA, "Calculated\nSample Size"),
                               col = c(simcolor, NA, "red"),
                               pch = c(rep(19,3), -1, 19),
                               y.intersp = 0.25,
                               cex = 0.7
                        )
                        

                })
                })                
        }
)