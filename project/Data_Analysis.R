library(tidyverse)
library(dslabs)
library(dplyr)

# Load your datasets 
df = read.csv("socio_economic_data_with_continent.csv")

# view the datasets
view(df)
class(df)
str(df)

# unique continents
unique_values <- unique(df$continent)
unique_values

unique_values2 <- unique(df$region)
unique_values2



# ----------------------------------   objective 1     -----------------------------
# differences in infant mortality across different countries.
filtered_Infant <- df %>% filter(year == 2021 & country %in% c('Sri Lanka', 'Malta', 'Turkiye', 'Poland', 'Malaysia', 'Pakistan', 
                                                               'Thailand', 'Romania', 'Russian Federation', 'South Africa', 'Vietnam', 
                                                               'Ukraine', 'Bulgaria', 'Japan', 'United Kingdom', 'United States', 'Korea, Rep.')) %>%
  select(year,continent, country, infant_Mortality) %>% arrange(desc(infant_Mortality))

# View the filtered data
filtered_Infant

# ---------------------------------------------    ------------------------------------------------------------------

# Visualize the differences in infant mortality across different countries.
library(ggplot2)
library(gridExtra)
library(grid)

filtered_Infant <- df %>% 
  filter(year == 2021 & country %in% c('Sri Lanka', 'Malta', 'Turkiye', 'Poland', 'Malaysia', 'Pakistan', 
                                       'Thailand', 'Romania', 'Russian Federation', 'South Africa', 'Vietnam', 
                                       'Ukraine', 'Bulgaria', 'Japan', 'United Kingdom', 'United States', 'Korea, Rep.')) %>%
  select(year,continent, country, infant_Mortality) %>%
  arrange(desc(infant_Mortality))

# Create the plot
plot <- ggplot(filtered_Infant, aes(x = country, y = as.numeric(infant_Mortality))) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(x = "Country", y = "Infant Mortality 2021", title = "Infant Mortality Across Countries") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(plot.title = element_text(face = "bold", size = 16)) +
  geom_text(aes(label = infant_Mortality), vjust = -0.5, size = 4, fontface = "bold")

# Display the filtered data table
table <- grid.table(filtered_Infant, rows = NULL, theme = ttheme_default(base_size = 16, core = list(fg_params = list(fontface = "bold"))))


# Arrange the plot and table side by side
combined <- grid.arrange(plot, table, ncol = 2)
dev.off()



# ---------------------   analysis of world view    ----------------------------
filtered2 <- df %>% filter(year == 1960 & !is.na(continent)) %>% ggplot( aes(fertility_rate, life_expectancy, color = continent)) + geom_point() + facet_grid(. ~ year)
filtered2

# ------------ 61 years later -----------

filter3 <- df %>% filter(year%in%c(1960, 2021) & !is.na(continent)) %>% 
  ggplot(aes(fertility_rate, life_expectancy, col = continent)) + geom_point() +
  facet_grid(. ~ year)

filter3

filter3 <- df %>% filter(year%in%c(1960, 2021) & !is.na(continent)) %>% 
  ggplot(aes(fertility_rate, life_expectancy, col = continent)) + geom_point() +
  facet_wrap(. ~ year, scales = "free")

filter3




# ---------------- objective Two ------------------



df <- df %>% mutate(Dollars_per_Day = GDP/population/365)



past_year <- 1960
df %>% filter(year == past_year & !is.na(GDP)) %>% 
  ggplot(aes(Dollars_per_Day)) + 
  geom_histogram(binwidth = 1, color = "black") + 
  scale_x_continuous(trans = "log2") + facet_grid(. ~ year)




df %>%
  filter(year == past_year & !is.na(GDP)) %>%
  mutate(region = reorder(region, Dollars_per_Day, FUN = median)) %>% ggplot(aes(Dollars_per_Day, region)) +
  geom_point() +
  scale_x_continuous(trans = "log2") + facet_grid(. ~ year)



df %>%
  filter(year == past_year & !is.na(GDP)) %>%
  mutate(region = reorder(region, Dollars_per_Day, FUN = median)) %>% ggplot(aes(Dollars_per_Day, region)) +
  geom_point() +
  scale_x_continuous(trans = "log2") + facet_grid(. ~ year)




df <- df %>% mutate(group = case_when(
  region %in% c("North America", "Europe & Central Asia", "Latin America & Caribbean") ~ "West",
  region %in% c("East Asia & Pacific", "South Asia") ~ "East Asia", 
  region %in% c("Latin America & Caribbean") ~ "Latin America", continent == "Africa" &
    region != "Northern Africa" ~ "Sub-Saharan", TRUE ~ "Others"))


df <- df %>%
  mutate(group = factor(group, levels = c("Others", "Latin America",
                                          "East Asia", "Sub-Saharan",
                                          "West")))


p <- df %>%
  filter(year == past_year & !is.na(GDP)) %>% ggplot(aes(group, Dollars_per_Day)) +
  geom_boxplot() +
  scale_y_continuous(trans = "log2") +
  xlab("") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
p

present_year <- 2021

country_list_1 <- df %>% filter(year == past_year & !is.na(Dollars_per_Day)) %>% pull(country)
country_list_2 <- df %>% filter(year == present_year & !is.na(Dollars_per_Day)) %>% pull(country)
country_list <- intersect(country_list_1, country_list_2)



years <- c(past_year, present_year)
df %>% filter(year %in% years & country %in% country_list) %>% mutate(year = factor(year)) %>%
  ggplot(aes(group, Dollars_per_Day, fill = year)) + geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_y_continuous(trans = "log2") +
  xlab("")








years <- c(past_year, present_year)
df %>% filter(year %in% years & !is.na(continent)) %>% mutate(year = factor(year)) %>%
  ggplot(aes(group, Dollars_per_Day, fill = year)) + geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + scale_y_continuous(trans = "log2") +
  xlab("")
