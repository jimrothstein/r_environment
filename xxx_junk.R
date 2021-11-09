f <- function(){
  print(x)
  on.exit(traceback())}


g <- function(){
  x = 100
  f()
}


{
  x <- NULL
browser()
x = 10

g()
}
