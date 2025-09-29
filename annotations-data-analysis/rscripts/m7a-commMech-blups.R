
library(lme4)       # mixed models

output_version = 3

outputparentdir = sprintf("%s/../regression-models/1grams/v%d", getwd(), output_version)

codebook_version = 2

outputdir = sprintf("%s/codebook%d", outputparentdir, codebook_version)

rds7a = sprintf("%s/m7a-helping-poisson.rds", outputdir)

m7 = readRDS(rds7a)

rds7r = sprintf("%s/m7-ranef.rds", outputdir)

start.time = Sys.time()

r7 = ranef(m7, whichel=c("commMech"), condVar=TRUE)

end.time = Sys.time()
print(end.time - start.time)

saveRDS(r7, file=rds7r)

