# Blups for m6
# Runs in 1.2 hours

library(lme4)       # mixed models

output_version = 3

# dw this is actually for input in this context
outputparentdir = sprintf("%s/../../regression-models/1grams/v%d", 
                          getwd(), output_version)

codebook_version = 3

outputdir = sprintf("%s/codebook%d", outputparentdir, codebook_version)

rds6a = sprintf("%s/m6a-content-poisson.rds", outputdir)

m6 = readRDS(rds6a)

rds6r = sprintf("%s/m6-ranef.rds", outputdir)

start.time = Sys.time()

r6 = ranef(m6, condVar=TRUE)

end.time = Sys.time()
print(end.time - start.time)

saveRDS(r6, file=rds6r)
