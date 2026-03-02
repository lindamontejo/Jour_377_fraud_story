#### Selecting relevant variables and fixing variable names  ------


# load packages
library(tidyverse)
library(here)
library(lubridate)


# read in data 
fraud_data <- read_tsv(here("data/survey_data/fraud_data.tsv")) |>
  janitor::clean_names()
chicago_crime <- read_csv("data/chicago_crime_data/chicago_crime_2024.csv")



#### Cleaning data -----
fraud_variables <- fraud_data |> 
  # selecting relevant variables
  select(puf_id, group, state, birth_year, a1, a6, a4, a7, a10, a13, b1a, b1b, b8, c4a_1, c4a_2, c4a_3, d5, d10) |> 
  # renaming variables for easier reference 
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



clean_fraud_survey <- fraud_variables |> 
  # replacing values with NA 
  mutate(
    across(where(is.numeric), ~ na_if(.x, -99)), 
    across(where(is.numeric), ~ na_if(.x, 88)), 
    across(where(is.numeric), ~ na_if(.x, 9999))) |> 
  # relabeling observations 
           mutate(
             paid_money = factor(paid_money, levels = c("1", "2"), labels = c("yes", "no")), 
             contact_method = factor(contact_method, levels = c("1", "2", "3", "4"), labels = c("yes", "no", "don't remember", "doesn't apply")), 
             product_recieved = factor(product_recieved, levels = c("1", "2"), labels = c("yes", "no")), 
             partner_investment = factor(partner_investment, levels = c("1", "2"), labels = c("yes", "no")), 
             fake_charity = factor(fake_charity, levels = c("1", "2", "3", "4"), labels = c("yes", "no", "don't remember", "doesn't apply")), 
             false_family = factor(false_family, levels = c("1", "2"), labels = c("yes", "no")),
             contact_law_enforcement = factor(contact_law_enforcement, levels = c("1", "2", "3", "4"), labels = c("yes", "no", "don't remember", "doesn't apply")), 
             contact_consumer_agency = factor(contact_consumer_agency, levels = c("1", "2", "3", "4", "77"), labels = c("yes", "no", "doesn't apply", "don't remember", "not selected")), 
             determining_scam = factor(determining_scam, levels = c("1", "2", "3", "4", "5", "6"), labels = c("very hard", "somewhat hard", "neither", "somewhat easy", "very easy", "doesn't apply")), 
             read_mail = factor(read_mail, levels = c("1", "2", "3", "4"), labels = c("almost every time", "usually", "occasionally", "almost never")), 
             sweepstakes = factor(sweepstakes, levels = c("1", "2", "3", "4"), labels = c("almost every time", "usually", "occasionally", "almost never")),
             unknown_caller = factor(unknown_caller, levels = c("1", "2", "3", "4"), labels = c("almost every time", "usually", "occasionally", "almost never")),
             married = factor(married, levels = c("1", "2", "3", "4", "5"), labels = c("married", "widowed", "divorced", "seperated", "never married")), 
             education = factor(education, levels = c("1", "2", "3", "4", "5", "6", "7", "8", "9"), labels = c("no high school diploma", "GED, high shool graduate", "no degree", "trade school", "associate's", "bachelor's", "master's", "professional", "graduate")), 
             # added age as a variable for easier analysis 
             age = year(Sys.Date()) - birth_year
           )

# save out data set with changes
save(clean_fraud_survey, file = here("data/survey_data/clean_fraud_survey.rda"))  

