# Fit Content model (RQ 2.1), negative binomial with nAGQ=0

input_version = 5

library(lme4)       # mixed models
library(dplyr)      # dataframe manipulation
library(readr)      # reading in the data
library(stringr)    # for interacting with strings

codebook_version = 3

fin = sprintf("../../derived-dataframes/regression-data-v%d/codebook%d_conv-annotator-code-speaker_outcome-counts.csv.gz", 
              input_version, codebook_version)
da = read_csv(fin)

da6 = da %>% filter(str_starts(da$code, "Questioning > ") | 
                      str_starts(da$code, "Helping > "))

# Data management
newcols = str_split_fixed(da6$code, " > ", 2)
da6["QH"] = newcols[,1]                                        # questioning vs helping
da6["I.Q"] = ifelse(da6$QH == "Questioning", 1, 0)
da6["I.H"] = ifelse(da6$QH == "Helping",     1, 0)

newcols = newcols[,2]                                          # get attributes only
newcols = substring(newcols, first=2, last=nchar(newcols) - 1) # remove parens
newcols = str_split_fixed(newcols, ", ", 2)
da6[c("mech.type", "content")] = newcols

da6["quesType"] = ifelse(da6$I.Q, da6$mech.type, "other")
da6["commMech"] = ifelse(da6$I.H, da6$mech.type, "other")

f6 = paste("count ~ request + speakerIsLearner + QH", 
           # code
           "(1|content) + (0+I.Q|quesType) + (0+I.H|commMech)", 
           "(0+I.Q|content:quesType) + (0+I.H|content:commMech)", 
           # conversation
           "(1|conversation_sharedID)", 
           "(1|conversation_sharedID:content)", 
           "(0+I.Q|conversation_sharedID:quesType)", 
           "(0+I.H|conversation_sharedID:commMech)", 
           "(0+I.Q|conversation_sharedID:content:quesType)", 
           "(0+I.H|conversation_sharedID:content:commMech)", 
           # annotator
           "(1|annotator)", 
           "(1|annotator:content) + (0+I.Q|annotator:quesType)", 
           "(0+I.H|annotator:commMech)", 
           "(0+I.Q|annotator:content:quesType) + (0+I.H|annotator:content:commMech)", 
           # 2-way among request, speaker, and code
           "(1|request:speakerIsLearner)", 
           # request : code
           "(1|request:content) + (0+I.Q|request:quesType) + (0+I.H|request:commMech)", 
           "(0+I.Q|request:content:quesType) + (0+I.H|request:content:commMech)", 
           # speaker : code
           "(1|speakerIsLearner:content)", 
           "(0+I.Q|speakerIsLearner:quesType) + (0+I.H|speakerIsLearner:commMech)", 
           "(0+I.Q|speakerIsLearner:content:quesType)", 
           "(0+I.H|speakerIsLearner:content:commMech)", 
           # 3-way among request, speaker, and code
           "(1|request:speakerIsLearner:content)", 
           "(0+I.Q|request:speakerIsLearner:quesType)", 
           "(0+I.H|request:speakerIsLearner:commMech)", 
           "(0+I.Q|request:speakerIsLearner:content:quesType)", 
           "(0+I.H|request:speakerIsLearner:content:commMech)", 
           sep=" + ")

rds6b = sprintf("m6b-content-nb.rds")

start.time = Sys.time()

m6b = glmer.nb(f6, data=da6, 
               offset=ln_conversation_length, 
               nAGQ=0, # faster
               #nAGQ=1, # slower but necessary for profiling
               verbose=1, 
               control=glmerControl(optimizer = "nloptwrap"))

end.time = Sys.time()
print(end.time - start.time)
saveRDS(m6b, file=rds6b)

#print(summary(m6b))
