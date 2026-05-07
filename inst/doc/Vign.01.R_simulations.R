## -----------------------------------------------------------------------------
#| eval: false
# library(amp.sim)
# convert_nonmem("run1.mod", "example1", type_return = "deSolve")
# # convert_nonmem("run1.mod", "example2", type_return = "rxode2")
# # For rxode2/nlmixr2 it is advised to let the nonmem2rx package
# # do the translation, added value is that the model can also be use for fitting!
# convert_nonmem("run1.mod", "example2", type_return = "nonmem2rx")
# convert_nonmem("run1.mod", "example3", type_return = "mrgsolve")


## -----------------------------------------------------------------------------
#| eval: true
#| echo: false
library(amp.sim)
ret <- convert_nonmem(system.file("example_models/PK.1CMT.ORAL.COV.mod",package = "amp.sim"), 
                      paste0(tempdir(),"/example"), overwrite = TRUE,
                      type_return = "mrgsolve",control="string",mod_return = "CP")
mdl <- readLines(paste0(tempdir(),"/example.cpp"))
ret[grepl("mread",ret)] <- "mod <- mread(\"example.cpp\")"


## -----------------------------------------------------------------------------
#| eval: true
#| echo: false
#| class-output: fortranfree
ret <- readLines(system.file("example_models/PK.1CMT.ORAL.COV.mod",package = "amp.sim"))
cat(ret, sep="\n")


## -----------------------------------------------------------------------------
#| eval: false
# library(amp.sim)
# convert_nonmem(system.file("example_models/PK.1CMT.ORAL.COV.mod",package = "amp.sim"),
#                "example", type_return = "mrgsolve", mod_return = "CP")

## -----------------------------------------------------------------------------
#| eval: true
#| echo: false
#| class-output: cpp
#cat(ret,sep="\n")
cat(mdl,sep="\n")


## -----------------------------------------------------------------------------
#| echo: false
#| fig-width: 6
#| message: false
library(mrgsolve)
library(ggplot2)
mod  <- mread(paste0(tempdir(),"/example.cpp"))
evnt <- ev(amt = 100, ii = 24, addl = 1)
out  <- mod |> ev(evnt) |> mrgsim(end = 48, delta = 0.1, nid=10)
ggplot(out@data,aes(time,CP)) + geom_line() + scale_y_log10() + theme_bw()


## -----------------------------------------------------------------------------
#| fig-width: 6
#| fig-height: 4
#| message: false
#| warning: false
library(ggplot2)
parm <- c(WEIGHT = 70)               
mod  <- param(mod,parm)   
out  <- zero_re(mod) |> ev(evnt) |> mrgsim(end = 48, delta = 0.1, nid=1)
ggplot(out@data,aes(time,CP)) + geom_line() + scale_y_log10() + theme_bw()


## -----------------------------------------------------------------------------
#| fig-width: 6
#| fig-height: 4
#| message: false
#| warning: false
parm <- c(WEIGHT = 70)               
mod  <- param(mod,parm)   
out  <- mod |> ev(evnt) |> mrgsim(end = 48, delta = 0.1, nid=100)
ggplot(out@data,aes(time,CP, group=ID)) + geom_line(alpha=0.3) + 
  scale_y_log10() + theme_bw()


## -----------------------------------------------------------------------------
#| fig-width: 6
#| fig-height: 4
#| message: false
#| warning: false

library(dplyr)
parm  <- c(WEIGHT = 70)
mod   <- param(mod,parm)   

# sample from uncertainty and apply simulations
extf  <- system.file("example_models/PK.1CMT.ORAL.COV.ext",package = "amp.sim")
covf  <- system.file("example_models/PK.1CMT.ORAL.COV.cov",package = "amp.sim")
parms <- sample_par(ext = extf, covmat = covf, nrepl = 100, uncert = TRUE) |> 
  rename_with(~ sub("S", "", .x))

dosim <- function(df){
  zero_re(mod) |> ev(evnt) |>
    param(c(unlist(df),parm)) |> 
    mrgsim_df(end = 48, delta = 0.1, nid=1) |>
    mutate(ID = unique(df$ID))  
}

out <- parms |> group_by(ID) |>
  group_map(~dosim(.x),.keep=TRUE) |> bind_rows()

ggplot(out,aes(time,CP,group=ID)) + geom_line(alpha=.3) + 
  scale_y_log10() + theme_bw()


## -----------------------------------------------------------------------------
#| eval: false
# parm  <- c(WEIGHT = 70)
# extf  <- system.file("example_models/PK.1CMT.ORAL.COV.ext",package = "amp.sim")
# covf  <- system.file("example_models/PK.1CMT.ORAL.COV.cov",package = "amp.sim")
# 
# parms <- sample_par(ext = extf, covmat = covf, nrepl=10, uncert=TRUE)
# parms <- setNames(parms,sub("S","",names(parms)))
# 
# library(parallel)
# cl  <- makeCluster(getOption("cl.cores", 7))
# clusterExport(cl, c("evnt","parms","mod","parm"))
# out <- parLapply(cl, 1:nrow(parms),function(x){
#   library(mrgsolve)
#   ret     <- mod |> ev(evnt) |> param(c(unlist(parms[x,]),parm)) |>
#                mrgsim_df(end = 48, delta = 0.1, nid=10)
#   ret$REP <- unique(parms$ID[x])
#   ret
# })
# stopCluster(cl)
# 
# out <- do.call(rbind,out)
# ggplot(out,aes(time,CP,group=ID)) + geom_line(alpha=.3) +
#   scale_y_log10() + facet_wrap("REP",labeller = "label_both") +
#   theme_bw()
# 


## -----------------------------------------------------------------------------
#| echo: false
#| fig-width: 6
#| fig-height: 4
#| message: false
#| warning: false
# Perform actual sims without parallel, because do not want to compile it (on CRAN) with this package
parm  <- c(WEIGHT = 70)
parms <- sample_par(ext    = system.file("example_models/PK.1CMT.ORAL.COV.ext",package = "amp.sim"),
                    covmat = system.file("example_models/PK.1CMT.ORAL.COV.cov",package = "amp.sim"),
                    nrepl=10, uncert=TRUE)
parms <- setNames(parms,sub("S","",names(parms)))
out <- lapply(1:nrow(parms),function(x){
  ret     <- mod |> ev(evnt) |> param(c(unlist(parms[x,]),parm)) |>
               mrgsim_df(end = 48, delta = 0.1, nid=10)
  ret$REP <- unique(parms$ID[x])
  ret
})
out <- do.call(rbind,out)
ggplot(out,aes(time,CP,group=ID)) + geom_line(alpha=.3) + 
  scale_y_log10() + facet_wrap("REP",labeller = "label_both") + 
  theme_bw()



## -----------------------------------------------------------------------------
tmpl_model()


## -----------------------------------------------------------------------------
#| eval: false
# tmpl_model("ana1CMTivC.tmp")


## -----------------------------------------------------------------------------
#| echo: true
#| fig-width: 6
#| fig-height: 4
#| message: false
#| warning: false
library(ggplot2)
ana1CMTiv <- function(Dose,pars,t,dur){
  C <- 1/pars['V']
  L <- pars['CL']/pars['V']
  ifelse(t <= dur,
    (Dose/dur) * C / L * (1-exp(-L * t)),
    (Dose/dur) * C / L * (1-exp(-L * dur)) * exp(-L * (t-dur))
  )
}
pars   <- c(CL=1,V=1)
times  <- seq(0,24,length.out=200)
out    <- mdose(Dose = 10, tau = 24, ndose = 1, t = times,
                func = ana1CMTiv, pars = pars, dur = 2)
ggplot(out,aes(time,y)) + geom_line() + theme_bw()



## -----------------------------------------------------------------------------
#| eval: false
# samp <- data.frame(CL=rnorm(100,10,1),V=rnorm(100,5,0.5))
# out <- lapply(1:nrow(samp), function(x){
#   data.frame(mdose(Dose=10,tau=24,ndose=1,t=times,func=ana1CMTiv,
#                    pars=unlist(samp[x,]),dur=2),ID=x)
# })
# out <- do.call(rbind,out)

