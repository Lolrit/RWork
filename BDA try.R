library(Hmisc)
library(epitools)
library(data.table)
brfss <- sasxport.get("C:/Users/Administrator/Desktop/LLCP2013XPT/LLCP2013.XPT")
dim(brfss)
object.size(brfss)
brfss$has_plan <- brfss$hlthpln1 == 1
summary(glm(has_plan ~ as.factor(x.race),
            data=brfss, family=binomial))
rows_to_select <- sample(1:nrow(brfss), 500, replace=F)
brfss_sample <- brfss[rows_to_select,]
oddsratio(brfss_sample$has_plan, as.factor(brfss_sample$x.race))
brfss_dt <- data.table(brfss)
object.size(brfss_dt)
object.size(brfss) 
