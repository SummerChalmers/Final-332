# Final-332
flower
## Contributors
Summer Chalmers & Hannah Maurer

## Introduction
In this project we chose people who have asthma and air pollution in the State of California. Asthma is split by lifetime and current, meaning people who were born with it and people who contracted it over time. The pollution was measure by the totals of each element in the air at a given location. All the data was recorde in between the years 2000 and 2020. 

## Cleaning Data

Removing any empty rows

```
asthma2012_present <- asthma2012_present[, !(names(asthma2012_present) == "X")]
asthma2012_present <- asthma2012_present[, !(names(asthma2012_present) == "X.1")]
asthma2012_present <- asthma2012_present[, !(names(asthma2012_present) == "X.2")]
asthma2012_present <- na.omit(asthma2012_present)
airquality <- airquality[, !(names(airquality) == "Date.Time")]
```

Merging all the data

```
df1 <- merge(airquality, asthma1995_2011, by = "Year")
df2 <- merge(airquality, asthma2012_present, by = "Year")
df <- bind_rows(df1,df2)
```

Creating a location column based off of Site ID

```
location_key <- data.frame(
  SITE_ID = c('LAV410', 'JOT403', 'YOS404', 'PIN414', 'SEK430', 'DEV412'),
              location = c('Shasta', 'San Bernardino', 'Mariposa', 'San Benito', 'Tulare','Inyo'))
df <- df %>%
  left_join(location_key, by = 'SITE_ID')
```
