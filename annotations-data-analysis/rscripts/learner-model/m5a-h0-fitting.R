# Fit Learner questions model (RQ 1.1), Poisson, nested (no request:content interactions) with nAGQ=0

input_version = 5

library(lme4)       # mixed models
library(dplyr)      # dataframe manipulation
library(readr)      # reading in the data
library(stringr)    # for interacting with strings

codebook_version = 3

fin = sprintf("../../derived-dataframes/regression-data-v%d/codebook%d_conv-annotator-code-speaker_outcome-counts.csv.gz", 
              input_version, codebook_version)
da = read_csv(fin)

da5 = da %>% filter(str_starts(da$code, "Questioning > ") & da$speakerIsLearner)

# Data management
da5["code"] = substring(da5$code, 
                        first=nchar("Questioning > ") + 2, 
                        last=nchar(da5$code)-1)
newcols = str_split_fixed(da5$code, ", ", 2)
da5[c("questionType", "contentDomain")] = newcols

f5 = paste("count ~ request", 
           "(1|conversation_sharedID) + (1|annotator)", 
           # code
           "(1|contentDomain)", "(1|questionType)", "(1|contentDomain:questionType)", 
           # annotator : code
           "(1|annotator:contentDomain)", "(1|annotator:questionType)", 
           "(1|annotator:contentDomain:questionType)", 
           # conversation : code
           "(1|conversation_sharedID:contentDomain)", "(1|conversation_sharedID:questionType)", 
           "(1|conversation_sharedID:contentDomain:questionType)", 
           # request : code
           #"(1|request:contentDomain)", 
           "(1|request:questionType)", 
           "(1|request:contentDomain:questionType)", 
           sep=" + ")

rds5a.h0 = sprintf("m5a-learner-questions-h00-poisson.rds")

start.time = Sys.time()

m5a = glmer(f5, data=da5, family=poisson(link=log), 
            offset=ln_conversation_length, 
            nAGQ=0, # faster
            #nAGQ=1, # slower but necessary for profiling
            verbose=TRUE, 
            control=glmerControl(optimizer = "nloptwrap"))

end.time = Sys.time()
print(end.time - start.time)
saveRDS(m5a, file=rds5a.h0)

#print(summary(m1a))
