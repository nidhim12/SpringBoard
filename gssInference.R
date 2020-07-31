library(dplyr)
library(plyr)
library(data.table)
library(knitr)
library(reshape2)

## Part 1: Data

load(gzfile(file.choose()))
save(gss,file="gss.RData")
new_gss <- load(gss.RData)
str(gss)
head(gss)

df <- select(gss, year, race, age, income06, joblose)

head(df)
str(df)
data(df)
## Part 2: Research question
##To research if there is a relationship between race of an individual and his/her job security?

## Part 3: Exploratory data analysis

na_count <- sapply(df, function(df) sum(length(which(is.na(df)))))
na_count <- data.frame(na_count)

df %>%
  group_by(race, income06, joblose) %>% tally()


completerecords <- na.omit(df) 

completerecords %>%
  group_by(race) %>% 
summarise(m_min = min(income06), m_max = max(income06), mean = mean(income06))

completerecords %>%
  group_by(race, income06, joblose) %>% tally()

setDT(completerecords)

df_m1 = dcast(completerecords, race ~ joblose, value.var="joblose", fun.aggregate= length)

df_m1 <- data.frame('Very Likely' = c(100, 49, 33), 'Fairly Likely' = c(138,55, 41), 'Not Too Likely' = c(758, 139, 106), 'Not Likely' = c(1608, 257, 206),
                row.names = c("White", "Black", "Other"), stringsAsFactors = FALSE)    
df_m1["Total" ,] <- colSums(df_m1)

## Part 4: Inference

DF = (3-1)*(4-1)

chi_squared =  (100-136)^2/136 + (138-175)^2/175 + (758-748)^2/748 + (1608-1545)^2/1545 + (49-26)^2/26 + (55-34)^2/34 + (139-144)^2/144 + (257-296)^2/296 + (33-20)^2/20 + (41-26)^2/26 + (106-111)^2/111 + (206-229)^2/229
chi_squared

p_val = pchisq(chi_squared, DF, lower.tail = FALSE)
p_val =7.929795e-15
