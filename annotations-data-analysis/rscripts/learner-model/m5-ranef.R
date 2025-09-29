# Blups for m5
# Runs in 4 minutes

library(lme4)       # mixed models

output_version = 3

outputparentdir = sprintf("%s/../../regression-models/1grams/v%d", getwd(), output_version)

codebook_version = 3

outputdir = sprintf("%s/codebook%d", outputparentdir, codebook_version)

rds5a = sprintf("%s/m5a-learner-questions-poisson.rds", outputdir)

m5 = readRDS(rds5a)

rds5r = sprintf("%s/m5-ranef.rds", outputdir)

start.time = Sys.time()

r5 = ranef(m5, condVar=TRUE)

end.time = Sys.time()
print(end.time - start.time)

saveRDS(r5, file=rds5r)
