# fixing variable names 


# load packages
library(tidyverse)
library(here)


# read in data 
fraud_data <- read_tsv(here("data/fraud_data.tsv")) |>
  janitor::clean_names()



# Clean data 
fraud <- crime |> 
  filter(text_general_code == "Fraud")
chicago_crime <- read_csv("chicago_crime_2024.csv")

fraud_variables <- fraud_data |> 
  select(puf_id, group, state, birth_year, a1, a6, a4, a7, a10, a13, b1a, b1b, b8, c4a_1, c4a_2, c4a_3, d5, d10) |> 
  rename(
    id = puf_id, 
    paid_money = a1, 
    contact_method = a6,
    product_recieved = a4, 
    partner_investment  = a7, 
    fake_charity = a10, 
    false_family = a13, 
    contact_law_enforcement = b1a,
    contact_consumer_agency = b1b, 
    determining_scam= b8,
    read_mail = c4a_1, 
    sweepstakes = c4a_2,
    unknown_caller = c4a_3,
    married = d5,
    education = d10
  )


# changing the observations 
clean_fraud_survery <- fraud_variables |> 
  mutate(
    paid_money = factor(paid_money, levels = c("1", "2", "88", "99"), labels = c("yes", "no", "NA", "NA")), 
    contact_method = factor(contact_method, levels = c("1", "2", "3", "4", "88", "99"), labels = c("yes", "no", "don't remember", "doesn't apply", "NA", "NA")), 
    product_recieved = factor(product_recieved, levels = c("1", "2", "88", "99"), labels = c("yes", "no", "NA", "NA")), 
    partner_investment = factor(partner_investment, levels = c("1", "2", "88", "99"), labels = c("yes", "no", "NA", "NA")), 
    fake_charity = factor(fake_charity, levels = c("1", "2", "3", "4", "88", "99"), labels = c("yes", "no", "don't remember", "doesn't apply", "NA", "NA")), 
    false_family = factor(false_family, levels = c("1", "2", "88", "99"), labels = c("yes", "no", "NA", "NA")),
    contact_law_enforcement = factor(contact_law_enforcement, levels = c("1", "2", "3", "4", "88", "99"), labels = c("yes", "no", "don't remember", "doesn't apply", "NA", "NA")), 
    contact_consumer_agency = factor(contact_consumer_agency, levels = c("1", "2", "3", "4","77", "88", "99"), labels = c("yes", "no", "NA", "don't remember", "not selected", "NA", "NA")), 
    determining_scam = factor(determining_scam, levels = c("1", "2", "3", "4", "5", "6", "99"), labels = c("very hard", "somewhat hard", "neither", "somewhat easy", "very easy", "NA", "NA")), 
    read_mail = factor(read_mail, levels = c("1", "2", "3", "4", "99"), labels = c("almost every time", "usually", "occasionally", "almost never", "NA")), 
    sweepstakes = factor(sweepstakes, levels = c("1", "2", "3", "4", "99"), labels = c("almost every time", "usually", "occasionally", "almost never", "NA")),
    unknown_caller = factor(unknown_caller, levels = c("1", "2", "3", "4", "99"), labels = c("almost every time", "usually", "occasionally", "almost never", "NA")),
    married = factor(married, levels = c("1", "2", "3", "4", "5", "99"), labels = c("married", "widowed", "divorced", "seperated", "never married", "NA")), 
    education = factor(education, levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9", "99"), labels = c("no high school diploma", "GED, high shool graduate", "no degree", "trade school", "associate's", "bachelor's", "master's", "professional", "graduate", "NA"))
  )

# save out data set with changes
save(clean_fraud_survery, file = here("data/clean_fraud_survey"))  