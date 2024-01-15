library(tidyverse)
library(dslabs)
library(dplyr)

# Load your datasets 
df = read.csv("Data2.csv")


# view the datasets
view(df)
class(df)
str(df)



# --------  changing the datatype of the variables --------------
df$year <- as.integer(df$year)
df$infant_Mortality <- as.numeric(df$infant_Mortality)
df$life_expectancy <- as.numeric(df$life_expectancy)
df$fertility_rate <- as.numeric(df$fertility_rate)
df$population <- as.numeric(df$population)
df$GDP <- as.numeric(df$GDP)


# ---------------- Adding continent and regions to the dataset -----------------

# Install and load the required package
install.packages("countrycode")
library(countrycode)


# Add the continent column
df$continent <- countrycode(df$country, "country.name", "continent")

# Add the region column
df$region <- countrycode(df$country, "country.name", "region")

# view the updated dataframe
view(df)


# --------------- Arranging the datatframe ------------

df <- df %>% select(continent, region, country, year, everything())

# view the updated dataframe
view(df)

# ---------- save the new arranged dataset ----------

write.csv(df, file = "socio_economic_data_with_continent.csv", row.names = FALSE)


