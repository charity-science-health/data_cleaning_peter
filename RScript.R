## import the tidyverse package
library(tidyverse)

## import datasets
enroll <- read_csv('Enrollment survey D2D partners 20190223_WIDE.csv')
vc1 <- read_csv('v1 Vaccination Card Photo Review d2d in house team - Vaccination Card.csv')
vc2 <- read_csv('v1 Vaccination Card Photo Review D2D Partners IDI Pilot - Vaccination Card.csv')
vc3 <- read_csv('v1 Vaccination Card Photo Review Hospital Workers - Vaccination Card.csv')

## filter the vaccination card dataframes by column numbers, and get them concatenated
cols = c('uniqID', 'X21', 'X24', 'X27', 'X30', 'X33', 'X36', 'X39', 'X42', 'X45',
         'X48', 'X51', 'X54')
new_vc <- bind_rows(tail(vc1[cols],-1), tail(vc2[cols],-1), tail(vc3[cols],-1))

## use left join to join the concatenated vaccination card table and enrollment table
joined_table <- left_join(new_vc, enroll, by=c("uniqID" = "KEY"))

## Find the duplicated uniqID
joined_table[duplicated(joined_table$uniqID), ]$uniqID

## Fill the vaccination dates of enrollment table with the dates info from vaccination table
joined_table$child1_date_vacc_card_BCG <- joined_table$X21
joined_table$child1_date_vacc_card_OPV0 <- joined_table$X24
joined_table$child1_date_vacc_card_OPV1 <- joined_table$X30
joined_table$child1_date_vacc_card_Penta1 <- joined_table$X33
joined_table$child1_date_vacc_card_OPV2 <- joined_table$X36
joined_table$child1_date_vacc_card_Penta2 <- joined_table$X39
joined_table$child1_date_vacc_card_OPV3 <- joined_table$X42
joined_table$child1_date_vacc_card_Penta3 <- joined_table$X45
joined_table$child1_date_vacc_card_MR1 <- joined_table$X51

## Export the final deliverable
joined_table$KEY <- joined_table$uniqID
colnames(joined_table)
records_changed <- joined_table$KEY
to_be_joined_1 <- filter(enroll, !KEY %in% records_changed)
to_be_joined_2 <- joined_table[,14:338]
final <- bind_rows(to_be_joined_1, to_be_joined_2)
write.csv(final,"final_deliverable.csv", row.names=FALSE)
