library(ggplot2)
library(shiny)
library(readxl)
library(dplyr)
library(lubridate)
library(rdflib)

#load data
#setwd('C:/Users/hanna/Documents/DATA 332/FinalProject')

airquality <- read.csv("AirQuality.csv")
asthma1995_2011 <- read.csv("asthmaprevalence1995to2011.csv")
asthma2012_present <- read.csv("asthmaprevalence2012topresent.csv")

#remove empty rows from data set
asthma2012_present <- asthma2012_present[, !(names(asthma2012_present) == "X")]
asthma2012_present <- asthma2012_present[, !(names(asthma2012_present) == "X.1")]
asthma2012_present <- asthma2012_present[, !(names(asthma2012_present) == "X.2")]
asthma2012_present <- na.omit(asthma2012_present)
airquality <- airquality[, !(names(airquality) == "Date.Time")]

#merge the data
df1 <- merge(airquality, asthma1995_2011, by = "Year")
df2 <- merge(airquality, asthma2012_present, by = "Year")
df <- bind_rows(df1,df2)

#clear non-used columns
df <- subset(df, select = -Ca.Dry)
df <- subset(df, select = -Ca.Wet)
df <- subset(df, select = -Cl.Dry)
df <- subset(df, select = -Cl.Wet)
df <- subset(df, select = -K.Dry)
df <- subset(df, select = -K.Wet)
df <- subset(df, select = -Mg.Dry)
df <- subset(df, select = -Mg.Wet)
df <- subset(df, select = -N.Dry)
df <- subset(df, select = -N.Dry.HNO3)
df <- subset(df, select = -N.Dry.NH3)
df <- subset(df, select = -N.Dry.NH4)
df <- subset(df, select = -N.Dry.NO3)  
df <- subset(df, select = -N.Dry.NOM)
df <- subset(df, select = -N.Dry.NOXI)
df <- subset(df, select = -N.Dry.NRED)
df <- subset(df, select = -N.Dry.TNO3)
df <- subset(df, select = -N.Wet)
df <- subset(df, select = -N.Wet.NH4)
df <- subset(df, select = -N.Wet.NO3)
df <- subset(df, select = -NA.Dry)
df <- subset(df, select = -NA.Wet)
df <- subset(df, select = -S.Dry)
df <- subset(df, select = -S.Dry.SO2)
df <- subset(df, select = -S.Dry.SO4)
df <- subset(df, select = -S.Wet)
df <- subset(df, select = -S.Wet.SO4)

#change the elements to numeric class
df$Ca.Total <- as.numeric(df$Ca.Total)
df$Cl.Total <- as.numeric(df$Cl.Total)
df$K.Total <- as.numeric(df$K.Total)
df$Mg.Total <- as.numeric(df$Mg.Total)
df$N.Total <- as.numeric(df$N.Total)
df$NA.Total <- as.numeric(df$NA.Total)
df$S.Total <- as.numeric(df$S.Total)
df$N.Total.NOXI <- as.numeric(df$N.Total.NOXI)
df$N.Total.NRED <- as.numeric(df$N.Total.NRED)
df$Precip <- as.numeric(df$Precip)

#location of sites
location_key <- data.frame(
  SITE_ID = c('LAV410', 'JOT403', 'YOS404', 'PIN414', 'SEK430', 'DEV412'),
  location = c('Shasta', 'San Bernardino', 'Mariposa', 'San Benito', 'Tulare', 'Inyo'))
df <- df %>%
  left_join(location_key, by = 'SITE_ID')

# Define UI
ui <- fluidPage(
  titlePanel("Asthma Air Quality Analysis"),
  tabsetPanel(
    tabPanel("Research",
             h4("There is irony when using this data because one group member is from California. We suspect that there will be higher pollution as the years progress. So the earlier years will have less people that are affected by asthma, but as the years go on there will be more people affected by asthma. The years the data was collected was 2000 to 2020. In the data asthma was separated into two different categories: lifetime and current. Lifetime means the person was born with it and current means the person developed it over time. The data was recorded in six different counties. First Shasta county that includes Redding in Northern California in the Sacramento Valley. The second is San Bernardino which includes eastern Los Angeles with areas such as Riverside and Ontario. The third is Mariposa County which is in the valley of California that includes some of Yosemite National Park. The fourth is San Benito which is the coastal area adjacent to Mariposa. The fifth one is Tulare which includes Bakersfield which is north of Los Angeles. Finally the county of Inyo which includes Death Valley and southwest portion of Yosemite National Park. There are seven elements that the data records in the air at each location: Calcium, Chlorine, Potassium, Magnesium, Nitrogen, Sodium, and Sulfur. Long term exposure to these elements can lead to health complications, sometimes more than just asthma. ")
    ),
    tabPanel("Requirements",
             h4("Requirements:"),
             HTML("<ul>
                <li>Creating charts within multiple tabs that display the data</li>
                <li>Formulating a paragraph to explain what the data is</li>
                <li>Explaining the story the data tells in a paragraph</li>
                <li>Create a functioning Shiny application that displays visuals supporting our hypothesis</li>
                <li>Researching each element and how they affect air quality</li>
                <li>Create a Kanban board to track the team's progress</li>
                <li>Maintain the Kanban board, keeping track of all aspects involved</li>
                <li>Create a GitHub repository with all the code, explaining what the code does in relation to our data</li>
              </ul>")),
    tabPanel("Yearly Element Chart",
             tabsetPanel(
               tabPanel("Ca Total by Year",
                        plotOutput("ca_total_by_year")),
               tabPanel("Cl Total by Year",
                        plotOutput("cl_total_by_year")),
               tabPanel("K Total by Year",
                        plotOutput("k_total_by_year")),
               tabPanel("Mg Total by Year",
                        plotOutput("mg_total_by_year")),
               tabPanel("N Total by Year",
                        plotOutput("n_total_by_year")),
               tabPanel("N Total NOXI by Year",
                        plotOutput("n_total_noxi_by_year")),
               tabPanel("N Total NRED by Year",
                        plotOutput("n_total_nred_by_year")),
               tabPanel("NA Total by Year",
                        plotOutput("na_total_by_year")),
               tabPanel("S Total by Year",
                        plotOutput("s_total_by_year"))
             )),
    tabPanel("Pecentage of Type of Asthma",
             plotOutput("percentage_of_type_of_asthma")),
    tabPanel("Precipitation by Location Each Year",
             plotOutput("precip_location")),
    tabPanel("Backlog",
             h4("Backlog:"),
             HTML("<ul>
                <li>Adding in a chart for lower and upper level confidence interval</li>
                <li>Elements by year all in one chart</li>
                <li>Using the location to create more charts</li>
              </ul>")),
    tabPanel("Conclusion",
             h4("The results of the data do support our hypothesis that air pollution worsened over the years, so that people in the later years of the data had asthma more than people in the earlier years of the 2000s. In the graph of percentage of asthma by the years it shows that the amount of people having asthma increased in the last four years. In most of the element graphs there seems to be a spike in 2018 which then levels back down after. This correlates to the spike in the asthma percentage graph where the amount of people with asthma spike higher than the previous years. The precipitation graph shows how much moisture is in the air. As you can see in the precipitation graph there is a decrease from 2017 to 2018. This means that after 2017 the air became more dyer, hence the more cases of asthma. Dry air worsens asthma. The spikes in the prescription graph show the decrease in the asthma percentage graph."))
  )
)

# Define server logic
server <- function(input, output) {
  
  output$ca_total_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = Ca.Total)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#ffd700") +
      labs(title = "Ca Total by Year", x = "Year", y = "Ca Total")+
      scale_y_continuous(breaks = seq(0, max(df$Ca.Total), by = 0.5))
  })
  output$cl_total_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = Cl.Total)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#000080") +
      labs(title = "Cl Total by Year", x = "Year", y = "Cl Total")+
      scale_y_continuous(breaks = seq(0, max(df$Cl.Total), by = 0.5))
  })
  output$k_total_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = K.Total)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#ff0800") +
      labs(title = "K Total by Year", x = "Year", y = "K Total")+
      scale_y_continuous(breaks = seq(0, max(df$K.Total), by = 0.5))
  })
  output$mg_total_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = Mg.Total)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#ef008c") +
      labs(title = "Mg Total by Year", x = "Year", y = "Mg Total")+
      scale_y_continuous(breaks = seq(0, max(df$Mg.Total), by = 0.05))
  })
  output$n_total_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = N.Total)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#65350f") +
      labs(title = "N Total by Year", x = "Year", y = "N Total")+
      scale_y_continuous(breaks = seq(0, max(df$N.Total), by = 1))
  })
  output$n_total_noxi_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = N.Total.NOXI)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#107c10") +
      labs(title = "N Total NOXI by Year", x = "Year", y = "N Total NOXI")+
      scale_y_continuous(breaks = seq(0, max(df$N.Total.NOXI), by = 1))
  })
  output$n_total_nred_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = N.Total.NRED)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#42f9f9") +
      labs(title = "N Total NRED by Year", x = "Year", y = "N Total NRED")+
      scale_y_continuous(breaks = seq(0, max(df$N.Total.NRED), by = 1))
  })
  output$na_total_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = NA.Total)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#b6b0ff") +
      labs(title = "Na Total by Year", x = "Year", y = "Na Total")+
      scale_y_continuous(breaks = seq(0, max(df$NA.Total), by = 0.5))
  })
  output$s_total_by_year <- renderPlot({
    ggplot(df, aes(x = Year, y = S.Total)) +
      geom_bar(stat = "identity", position = "dodge", fill = "#f15628") +
      labs(title = "S Total by Year", x = "Year", y = "S Total")+
      scale_y_continuous(breaks = seq(0, max(df$S.Total), by = 0.5))
  })
  output$percentage_of_type_of_asthma <- renderPlot({
    ggplot(df, aes(x = Year, y = Percent, fill = Measure)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Type of Asthma by Percent", x = "Year", y = "Percent")+
      scale_y_continuous(breaks = seq(0, max(df$Percent), by = 2))
  })
  output$precip_location <- renderPlot({
    ggplot(df, aes(x = Year, y = Precip, fill = location)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Precipitation by Location each Year", x = "Year", y = "Location")+
      scale_y_continuous(breaks = seq(0, max(df$Precip), by = 20))+
      scale_fill_manual(values = c("red", "blue", "green", 'yellow', 'pink', 'purple'))
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)

