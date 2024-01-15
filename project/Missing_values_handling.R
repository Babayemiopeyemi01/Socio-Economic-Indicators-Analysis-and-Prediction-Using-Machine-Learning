
# handling missing values using Multiple Imputation: Generate multiple imputed datasets by estimating missing values multiple times 
# using Markov Chain Monte Carlo (MCMC) techniques



# Install and load the 'mice' package
install.packages("mice")
library(mice)

# Load dataset 
data <- read.csv("socio_economic_data_with_continent.csv")

# Perform multiple imputation using MCMC
imputed_data <- mice(data, m = 10, method = "rf", seed = 123)

# Extract the imputed datasets
imputed_datasets <- complete(imputed_data, "long", include = TRUE)

# Access the imputed datasets

imputed_dataset <- imputed_datasets[, !(names(imputed_datasets) %in% c(".imp", ".id"))]

# Save the clean data

write.csv(imputed_dataset, file = "cleaned_socio_economic_indicators_data.csv", row.names = FALSE)


data3 <- read.csv("cleaned_socio_economic_indicators_data.csv")
View(data3)


