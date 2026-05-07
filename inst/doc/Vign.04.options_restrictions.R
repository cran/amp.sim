## ----eval=FALSE---------------------------------------------------------------
# # residual error and bio-availability can be added in the des_func e.g.
# CP  <- (A2/V) * F1 * (1 + rnorm(length(A2),0,sqrt(0.01)))
# # lag time should be adapted in the events data frame e.g.
# events      <- dose_func(cmt=1,value=300,ndose=3,tau=24)
# events$time <- events$time + pars['TLAG']
# # infusions should be handled in the event and are supported in dose_func
# # see template models how this can be adapted in the model part (?tmpl_model)
# dose_func(cmt=4,value=300,ndose=3,tau=24, tinf=2)

