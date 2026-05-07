## -----------------------------------------------------------------------------
library(amp.sim)
simd <- simdata(time = seq(0,120,1), dosetime = 0, doseheight = 100, 
                addl = 2, ii = 24, numid = 10)


## -----------------------------------------------------------------------------
#| eval: false
# # lapply can be used for multiple repetitions
# simd <- lapply(seq(300,600,1200),function(x) {
#   simdata(time = seq(0,120,1), dosetime = 0, doseheight = x,
#           addl = 2, ii = 24, numid = 10)
# })
# simd <- do.call(rbind,simd)
# # .. or rbind to do a few repetitions
# simd <- rbind(cbind(simd,CMT=1),cbind(simd,CMT=2),cbind(simd,CMT=3))


## -----------------------------------------------------------------------------
#| eval: false
# simd$WEIGHT <- 70
# simd$TRT    <- sample(1:3,10,replace=TRUE)
# simd$AGE    <- as.integer(rnorm(10,39,5))


## -----------------------------------------------------------------------------
#| eval: false
# # Simple sampling for 10 subjects with the same THETAs but different ETAs
# samp <- sample_par("run1.ext",inc_eta=TRUE,nrepl=10)
# 
# # We could include sampling with uncertainty and omit ETA values
# # samp <- sample_par("run2.ext","run2.cov",inc_eta=FALSE,nrepl=10,uncert = TRUE)
# 
# # Or have uncertainty and variability
# # samp <- sample_par("run2.ext","run2.cov",inc_eta=TRUE,nrepl=10,uncert = FALSE)
# 
# # Or use the result from a bootstrap to sample uncertainty
# # samp <- sample_par("run2.ext",bootstrap=".", uncert = TRUE)
# 
# # In case of clinical trial simulations where a combination of replicates and subjects
# # should be used, the sample_sim function can be used
# # samp <- sample_sim(ext="run2.ext",cov="run2.cov", type="unc_sameIIV", nrepl=10, nsub=20)


## -----------------------------------------------------------------------------
#| eval: false
# inp    <- merge(simd,samp)
# inp    <- inp[order(inp$ID,inp$TIME),]
# write.csv(inp,csv="sim.input.csv",row.names = FALSE, na = ".")


## -----------------------------------------------------------------------------
#| eval: true
#| echo: false
library(amp.sim)
simd <- simdata(time = seq(0,120,1), dosetime = 0,
                doseheight = 100, addl = 2, ii = 24, numid = 10)
simd$WEIGHT  <- 70
simd$AGE     <- as.integer(rnorm(10,39,5))
simd$STHETA1 <- 0.234
simd$STHETA2 <- 1.25
simd$STHETA3 <- 30.1
simd$SETA1   <- round(rnorm(nrow(simd),sd=0.2),3)
simd$SETA2   <- round(rnorm(nrow(simd),sd=0.1),3)

## -----------------------------------------------------------------------------
#| eval: true
head(simd)


## -----------------------------------------------------------------------------
#| eval: false
# make_nmsimmodel("run1.mod", smod = "sim1.mod", data = "sim.input.csv")


## -----------------------------------------------------------------------------
#| eval: false
# split_sim(data    = "sim.input.csv",
#           model   = "run2sim_final.mod",
#           locout  = "simulation",
#           splitby = "DOSE",
#           numout  = 3)


## -----------------------------------------------------------------------------
#| eval: false
# write.csv(head(inp),csv="sim.input.csv",row.names = FALSE, na = ".")
# make_nmsimmodel("run1.mod", smod = "sim1.mod", data = "sim.input.csv")
# 
# split_sim(data    = inp,
#           model   = "sim1.mod",
#           locout  = "simulation",
#           splitby = "DOSE",
#           numout  = 3)


## -----------------------------------------------------------------------------
#| eval: false
# # NOTE: THIS IS EXAMPLE CODE; run_models IS NOT A FUNCTION AVAILABLE IN THE PACKAGE
# mods <- list.files("simulation",pattern="\\.mod$",full.names = TRUE)
# run_models(mods)

