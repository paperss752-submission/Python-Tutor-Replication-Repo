# Profile the already-fitted Questioning model (RQ 2.3), Poisson with nAGQ = 1

library(lme4)       # mixed models
library(readr)      # reading in the data

m8a = readRDS("m8a-questions-poisson-nAGQ1.rds")

print("starting model profiling...")

start.time = Sys.time()

p8a = profile(m8a, devtol=1e-07, verbose=TRUE)

end.time = Sys.time()
tp = end.time - start.time
print(end.time - start.time)

saveRDS(p8a, "p8a-questions-poisson-profile.rds")

print("done profiling, starting confint estimation...")

start.time = Sys.time()

c8a = confint(p8a, verbose=TRUE)

end.time = Sys.time()
tc = end.time - start.time
print(end.time - start.time)

saveRDS(c8a, "c8a-questions-poisson-confint.rds")

print(tp)
print(tc)

write(sprintf("Profile time: %s\nConfint time: %s", strftime(tp), strftime(tc)), 
      file = "m8a-timelog.txt", 
      append=TRUE)
