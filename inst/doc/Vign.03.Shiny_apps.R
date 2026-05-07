## ----eval=FALSE---------------------------------------------------------------
# library(amp.sim)
# mod2shiny(parvector = c(THETA1=0.1,THETA2=0.3),
#           modfile   = 'model.cpp',
#           evnt      = ev(amt = 100, ii = 24, addl = 1),
#           naming    = c(THETA1 = "KA (1/h)", THETA2 = "CL (l/h)"),
#           framework = "mrgsolve"
#           outloc    = "simApp")


## ----echo=FALSE, out.width="100%"---------------------------------------------
#knitr::include_graphics("./shinyscreenshot.PNG")
#knitr::include_graphics(paste0(getwd(),"/shinyscreenshot.PNG"))
#knitr::include_graphics(file.path("..","man", "figures", "shinyscreenshot.PNG"))
#knitr::include_graphics(system.file("shinyscreenshot.PNG",package = "amp.sim"))


## ----eval=FALSE---------------------------------------------------------------
# # part added in ui.r
# numericInput(inputId = 'DOSE', label='Dose (mg):', value=100)
# # part added in server.r
# events <- ev(amt = input$DOSE, ii = 24, addl = 1)

