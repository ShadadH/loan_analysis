#---------------------#

#title: "Case 1 "
#date: "2024-04-05"

#--------------------#


install.packages("readxl")
library("readxl")
install.packages("tidyverse")
library(tidyverse)
install.packages('nnet')
library(nnet)
library(ggplot2)
install.packages("reshape2")
library(reshape2)



#Loading Data
loan_data = read_excel("/Users/macbookair/Downloads/DatasetRE.xlsx", sheet="Loan")
property_data = read_excel("/Users/macbookair/Downloads/DatasetRE.xlsx", sheet="Property")

#Renaming Columns
names(loan_data)[names(loan_data) == "Link to Propty/Lease List"] <- "Link"
names(property_data)[names(property_data) == "Link to Loan List"] <- "Link"


#Merging on Link and Removing Duplicates
merged_df <- merge(loan_data, property_data, by = "Link", all = TRUE)
merged_df <- merged_df %>% distinct(Link, .keep_all = TRUE)
dim(merged_df)

#Converting N/A String to NA Datatype
merged_df = merged_df %>% mutate(across(where(is.character), ~na_if(., "N/A")))

#Choose Columns to Keep
columns_to_keep <- c("Loan Name", "NOI(USD)","Origination Dt","St","Loan Status","Orig Amortization","Cap Rate","DSCR","Original Bal(USD)", "Appr Val(USD)")

# Subset the data frame using the selected columns
merged_df <- merged_df[, columns_to_keep]
Filter_data = na.omit(merged_df)


#Converting the Columns to Numeric
Filter_data$`NOI(USD)` <- as.numeric(Filter_data$`NOI(USD)`)
Filter_data$`Cap Rate` <- as.numeric(Filter_data$`Cap Rate`)
Filter_data$DSCR <- as.numeric(Filter_data$DSCR)
Filter_data$`Appr Val(USD)` = as.numeric(Filter_data$`Appr Val(USD)`)
Filter_data$`Orig Amortization` = as.numeric(Filter_data$`Orig Amortization`)

#The combination of the current Cols give 423 observations

#Creating a New Variable
Filter_data$`Origination Dt` <- as.Date(Filter_data$`Origination Dt`, "%m/%d/%y")

tday = Sys.Date() # Sys.Date() is a function that calls today's date 


# We have created a new column (Days.Since.Origination) to store this new composite variable

Filter_data$Days.Since.Origination <- tday - Filter_data$`Origination Dt`
Filter_data$Days.Since.Origination = as.numeric(Filter_data$Days.Since.Origination)

#Aggregate by Loan Status
summary_stats <- aggregate(cbind(DSCR, `Orig Amortization`,`NOI(USD)`,`Appr Val(USD)`,`Original Bal(USD)`) ~ `Loan Status`, data = Filter_data, 
                           FUN = function(x) c(mean = mean(x), median = median(x), sd = sd(x)))

print(summary_stats)

# Barplot of Loan_Status counts by State 
ggplot(Filter_data, aes(x = St, fill = `Loan Status`)) +
  geom_bar(position = "stack", width = 0.8) +
  labs(title = "Loan Status Counts by State",
       x = "State",
       y = "Count") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for better readability

# Boxplot of Days.Since.Origination by Loan_Status
ggplot(Filter_data, aes(x = `Loan Status`, y = Days.Since.Origination)) +
  geom_boxplot() +
  labs(title = "Boxplot of Days Since Origination by Loan Status",
       x = "Loan Status",
       y = "Days Since Origination") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Get the top 15 states by frequency count
top_states <- Filter_data %>%
  group_by(St) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice(1:15) %>%
  pull(St)

# Filter the data to include only the top 15 states
Filter_data_top15 <- Filter_data %>% filter(St %in% top_states)

# Create a table with count of each loan status by state
loan_status_counts <- table(Filter_data_top15$St, Filter_data_top15$`Loan Status`)

# Print the resulting table
print(loan_status_counts)

# Now, create the barplot with the filtered data
ggplot(Filter_data_top15, aes(x = St, fill = `Loan Status`)) +
  geom_bar(position = "stack") +
  
  labs(title = "Loan Status Counts by State (Top 15)",
       x = "State",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Histogram comparing numerical variables with loan status
ggplot(Filter_data, aes(x = Days.Since.Origination, fill = `Loan Status`)) +
  geom_histogram(position = "stack", bins = 30, alpha = 0.7) +
  labs(title = "Distribution of Days Since Origination by Loan Status",
       x = "Days Since Origination",
       y = "Frequency") +
  theme_minimal()

ggplot(Filter_data, aes(x = `Orig Amortization`, fill = `Loan Status`)) +
  geom_histogram(position = "stack", bins = 30, alpha = 0.7) +
  labs(title = "Distribution of Original Amortization by Loan Status",
       x = "Original Amortization",
       y = "Frequency") +
  theme_minimal()

ggplot(Filter_data, aes(x = `NOI(USD)`, fill = `Loan Status`)) +
  geom_histogram(position = "stack", bins = 30, alpha = 0.7) +
  labs(title = "Distribution of NOI (USD) by Loan Status",
       x = "NOI (USD)",
       y = "Frequency") +
  theme_minimal() ## Make into Pie Chart

ggplot(Filter_data, aes(x = `Appr Val(USD)`, fill = `Loan Status`)) +
  geom_histogram(position = "stack", bins = 30, alpha = 0.7) +
  labs(title = "Distribution of Appraised Value (USD) by Loan Status",
       x = "Appraised Value (USD)",
       y = "Frequency") +
  theme_minimal()

ggplot(Filter_data, aes(x = `Original Bal(USD)`, fill = `Loan Status`)) +
  geom_histogram(position = "stack", bins = 30, alpha = 0.7) +
  labs(title = "Distribution of Original Balance (USD) by Loan Status",
       x = "Original Balance (USD)",
       y = "Frequency") +
  theme_minimal()


# Define the limits for x and y axes
x_limits <- c(0, 5)  # Specify lower_limit and upper_limit for x-axis
y_limits <- c(0, 1000000)  # Specify lower_limit and upper_limit for y-axis

# Scatterplot with adjusted axis limits
ggplot(Filter_data, aes(x = DSCR, y = `NOI(USD)`, color = `Loan Status`)) +
  geom_point() +
  labs(title = "Scatterplot of DSCR vs. NOI(USD)",
       x = "DSCR",
       y = "NOI(USD)") +
  xlim(x_limits) +
  ylim(y_limits)


# Calculate correlations
correlation_matrix <- cor(Filter_data[, c("Days.Since.Origination", "Orig Amortization", "NOI(USD)", "Appr Val(USD)", "Original Bal(USD)")])

# Plot heatmap

ggplot(melt(correlation_matrix), aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "blue", high = "red") +
  labs(title = "Correlation Heatmap of Numerical Variables",
       x = "Variables",
       y = "Variables") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#As an experiment, we decided to run a multinomial logit regression. 
#There are many limitations with this as it compares it to the Late category which only has 2 data points, 
#and does not take into consideration heteroskedasticty and etc but we wanted to see if there was some relation between the variables none the less. 


logit_model <- multinom(formula = `Loan Status`  ~ DSCR + `NOI(USD)`+`Cap Rate`+ Days.Since.Origination +`Appr Val(USD)`, data = Filter_data)

# View summary of the logistic regression results
print(logit_model)


