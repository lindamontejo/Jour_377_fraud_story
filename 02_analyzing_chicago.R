# load packages
library(tidyverse)
library(here)



# read in data 
chicago <- read_csv(here("data/chicago_crime_data/chicago_crime_2024.csv")) |> 
  janitor::clean_names()




chicago_credit_card <- chicago |> 
  filter(description == "CREDIT CARD FRAUD")
write_csv(chicago_credit_card, file = "data/chicago_credit_card.csv")


chicago_fraud <- chicago |> 
  count(arrest) |>
  group_by(arrest) |> 
  mutate(percent = n / sum(n) * 100)
write_csv(chicago_fraud, file = "data/chicago_fraud.csv")

  