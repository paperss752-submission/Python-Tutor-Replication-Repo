# Fit Outcomes model (RQ 3.3), negative binomial with `request`-related random effects terms

input_version = 5

library(lme4)       # mixed models
library(dplyr)      # dataframe manipulation
library(readr)      # reading in the data

codebook_version = 1

fin = sprintf("../../derived-dataframes/regression-data-v%d/codebook%d_conv-annotator-code-speaker_outcome-counts.csv.gz", 
              input_version, codebook_version)
da = read_csv(fin)

da["numeric_outcome"] = ifelse(da$outcome == "S", 1, -1)
da["numeric_speakerIsLearner"] = ifelse(da$speakerIsLearner == TRUE, 1, -1)
da["LS_HF"] = ifelse(
  (da$speakerIsLearner & (da$outcome == "S")) | 
    (!da$speakerIsLearner & (da$outcome == "F")), 1, -1)

f1 = paste("count ~ outcome", 
           "(1|code) + (1|speakerIsLearner)", 
           "(1|conversation_sharedID) + (1|interaction(conversation_sharedID, code))", 
           "(1|annotator) + (1|interaction(annotator, code))", 
           "(1|request) + (1|interaction(request, code))",
           "(0+numeric_outcome|code) + (0+numeric_speakerIsLearner|code)", 
           "(0+LS_HF|code)",
           sep=" + ")

rds1b = sprintf("m1b-outcomes-nb-requestREs.rds")

print("starting model fitting...")

start.time = Sys.time()

m1b = glmer.nb(f1, data=da, 
               offset=ln_conversation_length, 
               nAGQ=0, # faster
               #nAGQ=1, # slower but necessary for profiling
               control=glmerControl(optimizer = "nloptwrap"), 
               verbose=TRUE)

end.time = Sys.time()
print(end.time - start.time)
saveRDS(m1b, file=rds1b)

print(summary(m1b))
