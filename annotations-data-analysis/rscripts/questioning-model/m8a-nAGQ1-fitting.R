# Fit Questioning model (RQ 2.3), Poisson with nAGQ = 1
# Fit in 2.3 days

input_version = 5

library(lme4)       # mixed models
library(dplyr)      # dataframe manipulation
library(readr)      # reading in the data
library(stringr)    # for interacting with strings

codebook_version = 2

fin = sprintf("../../derived-dataframes/regression-data-v%d/codebook%d_conv-annotator-code-speaker_outcome-counts.csv.gz", 
              input_version, codebook_version)
da = read_csv(fin)

da8 = da %>% filter(str_starts(da$code, "Questioning > "))
da8["code"] = substring(da8$code, 
                        first=nchar("Questioning > ") + 2, 
                        last=nchar(da8$code)-1)
newcols = str_split_fixed(da8$code, ", ", 3)
da8[c("content", "specificity", "quesType")] = newcols

f8 = paste("count ~ request + speakerIsLearner", 
           # code
           "(1|content) + (1|specificity) + (1|quesType)", 
           "(1|content:specificity) + (1|specificity:quesType) + (1|content:quesType)", 
           "(1|content:specificity:quesType)", 
           # conversation, conversation : code
           "(1|conversation_sharedID) + (1|conversation_sharedID:content)", 
           "(1|conversation_sharedID:specificity) + (1|conversation_sharedID:quesType)", 
           "(1|conversation_sharedID:content:specificity)", 
           "(1|conversation_sharedID:specificity:quesType)", 
           "(1|conversation_sharedID:content:quesType)", 
           #"(1|conversation_sharedID:content:specificity:quesType)", 
           # annotator, annotator : code
           "(1|annotator)", 
           "(1|annotator:content) + (1|annotator:specificity) + (1|annotator:quesType)", 
           "(1|annotator:content:specificity) + (1|annotator:specificity:quesType)", 
           "(1|annotator:content:quesType)", 
           #"(1|annotator:content:specificity:quesType)", 
           # 2-way between request, speaker, and code
           "(1|request:speakerIsLearner)", 
           # request : code
           "(1|request)", 
           "(1|request:content) + (1|request:specificity) + (1|request:quesType)", 
           "(1|request:content:specificity) + (1|request:specificity:quesType)", 
           "(1|request:content:quesType)", 
           #"(1|request:content:specificity:quesType)", 
           # speaker : code
           "(1|speakerIsLearner)", 
           "(1|speakerIsLearner:content) + (1|speakerIsLearner:specificity)", 
           "(1|speakerIsLearner:quesType)", 
           "(1|speakerIsLearner:content:specificity) + (1|speakerIsLearner:specificity:quesType)", 
           "(1|speakerIsLearner:content:quesType)", 
           #"(1|speakerIsLearner:content:specificity:quesType)", 
           # 3-way between request, speaker, and code
           "(1|request:speakerIsLearner)", 
           "(1|request:speakerIsLearner:content) + (1|request:speakerIsLearner:specificity)", 
           "(1|request:speakerIsLearner:quesType)", 
           #"(1|request:speakerIsLearner:content:specificity)", 
           #"(1|request:speakerIsLearner:specificity:quesType)", 
           #"(1|request:speakerIsLearner:content:quesType)", 
           #"(1|request:speakerIsLearner:content:specificity:quesType)", 
           sep=" + ")

rds8a = sprintf("m8a-questions-poisson.rds")

print("starting model fitting...")

start.time = Sys.time()

m8a = glmer(f8, data=da8, family=poisson(link=log), 
            offset=ln_conversation_length, 
            #nAGQ=0, # faster
            nAGQ=1, # slower but necessary for profiling
            control=glmerControl(optimizer = "nloptwrap"), 
            verbose=TRUE)

end.time = Sys.time()
print(end.time - start.time)
saveRDS(m8a, file=rds8a)

#print(summary(m8a))
