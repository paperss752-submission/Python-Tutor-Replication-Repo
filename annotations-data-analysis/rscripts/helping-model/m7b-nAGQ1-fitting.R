# Fit Helping model (RQ 2.2), negative binomial with nAGQ = 1

input_version = 5

library(lme4)       # mixed models
library(dplyr)      # dataframe manipulation
library(readr)      # reading in the data
library(stringr)    # for interacting with strings

codebook_version = 2

fin = sprintf("../../derived-dataframes/regression-data-v%d/codebook%d_conv-annotator-code-speaker_outcome-counts.csv.gz", 
              input_version, codebook_version)
da = read_csv(fin)

da7 = da %>% filter(str_starts(da$code, "Helping > "))
da7["code"] = substring(da7$code, 
                        first=nchar("Helping > ") + 2, 
                        last=nchar(da7$code)-1)
newcols = str_split_fixed(da7$code, ", ", 4)
da7[c("commMech", "certainty", "content", "specificity")] = newcols
da7["specificity"] = ifelse(da7$specificity == "", "unknown", da7$specificity)

f7 = paste("count ~ request + speakerIsLearner", 
           # code
           "(1|content) + (1|commMech) + (1|certainty) + (1|specificity)", 
           "(1|content:commMech) + (1|content:certainty) + (1|content:specificity)", 
           "(1|commMech:certainty) + (1|commMech:specificity) + (1|certainty:specificity)", # strategy
           "(1|content:commMech:certainty) + (1|content:commMech:specificity)", 
           "(1|content:certainty:specificity) + (1|commMech:certainty:specificity)", 
           # conversation, conversation : code
           "(1|conversation_sharedID)", 
           "(1|conversation_sharedID:content) + (1|conversation_sharedID:commMech)", 
           "(1|conversation_sharedID:certainty) + (1|conversation_sharedID:specificity)", 
           "(1|conversation_sharedID:content:commMech)", 
           "(1|conversation_sharedID:content:certainty)", 
           "(1|conversation_sharedID:content:specificity)", 
           "(1|conversation_sharedID:commMech:certainty)", 
           "(1|conversation_sharedID:commMech:specificity)", 
           "(1|conversation_sharedID:certainty:specificity)", 
           # skip higher-order interactions
           # annotator, annotator : code
           "(1|annotator)", 
           "(1|annotator:content) + (1|annotator:commMech)", 
           "(1|annotator:certainty) + (1|annotator:specificity)", 
           "(1|annotator:content:commMech)", 
           "(1|annotator:content:certainty)", 
           "(1|annotator:content:specificity)", 
           "(1|annotator:commMech:certainty)", 
           "(1|annotator:commMech:specificity)", 
           "(1|annotator:certainty:specificity)", 
           # skip higher-order interactions
           # 2-way between request, speaker, and code
           "(1|request:speakerIsLearner)", 
           # request : code
           "(1|request)", 
           "(1|request:content) + (1|request:commMech)", 
           "(1|request:certainty) + (1|request:specificity)", 
           "(1|request:content:commMech) + (1|request:content:certainty)", 
           "(1|request:content:specificity) + (1|request:commMech:certainty)", 
           "(1|request:commMech:specificity) + (1|request:certainty:specificity)", 
           # skip higher-order interactions
           # speaker : code
           "(1|speakerIsLearner)", 
           "(1|speakerIsLearner:content) + (1|speakerIsLearner:commMech)", 
           "(1|speakerIsLearner:certainty) + (1|speakerIsLearner:specificity)", 
           "(1|speakerIsLearner:content:commMech) + (1|speakerIsLearner:content:certainty)", 
           "(1|speakerIsLearner:content:specificity) + (1|speakerIsLearner:commMech:certainty)", 
           "(1|speakerIsLearner:commMech:specificity) + (1|speakerIsLearner:certainty:specificity)", 
           # skip higher-order interactions
           # 3-way between request, speaker, and code
           "(1|request:speakerIsLearner)", 
           "(1|request:speakerIsLearner:content) + (1|request:speakerIsLearner:commMech)", 
           "(1|request:speakerIsLearner:certainty) + (1|request:speakerIsLearner:specificity)", 
           # skip higher-order interactions
           sep=" + ")

rds7b = sprintf("m7b-helping-nb.rds")

print("starting model fitting...")

start.time = Sys.time()

m7b = glmer.nb(f7, data=da7, family=poisson(link=log), 
               offset=ln_conversation_length, 
               #nAGQ=0, # faster
               nAGQ=1, # slower but necessary for profiling
               control=glmerControl(optimizer = "nloptwrap"), 
               verbose=TRUE)

end.time = Sys.time()
print(end.time - start.time)
saveRDS(m7b, file=rds7b)

#print(summary(m7b))
