# load packages
library(tidyverse)
library(here)



# read in data 
load(here("data/survey_data/clean_fraud_survey.rda"))


fraud_survey <- clean_fraud_survey

# filtering for just the illinois results
illinois_fraud <- fraud_survey |> 
  filter(
    state == "IL", 
    paid_money == "yes", 
    product_recieved == "no"
  )

# Table 1: paying for product but not recieved 
# making a table of the percentage who paid money to scam. 
paid_money <- fraud_survey |> 
  count(paid_money) |> 
  mutate(percent = n / sum(n) * 100)

# adding another variable to the previous table 
paid_money <- fraud_survey |> 
  count(paid_money, product_recieved) |> 
  group_by(product_recieved) |> 
  mutate(percent = n / sum(n) * 100) |> 
  drop_na() # removing missing values from table 

# save out results 
write_csv(paid_money, file = "data/paid_money.csv")


# Table 2: 
# whether the theft was recored to the police 
law_table <- fraud_survey |> 
  filter(!is.na(contact_law_enforcement)) |> 
  count(contact_law_enforcement) |> 
  mutate(percent = n / sum(n) * 100) 

# save out results 
write_csv(law_table, file = "data/law_table.csv")

# whether the theft was recored to the the consumer agency 
consumer_table <- fraud_survey |> 
  filter(
         !is.na(contact_consumer_agency)) |> 
  count(contact_consumer_agency) |> 
  mutate(percent = n / sum(n) * 100)
  
# save out results 
write_csv(consumer_table, file = "data/consumer_table.csv")

# digital activity 
phone_usage <- fraud_survey |> 
  filter(
    !is.na(unknown_caller)) |> 
  count(unknown_caller) |> 
  mutate(percent = n / sum(n) * 100)

# save out results 
write_csv(phone_usage, file = "data/phone_usage.csv")

# extra tables
contact_method <- fraud_survey |> 
  count(contact_method, paid_money) |> 
  group_by(contact_method) |> 
  mutate(percent = n / sum(n) * 100)


