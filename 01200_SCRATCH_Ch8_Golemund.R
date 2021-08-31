##  Chapter 8, https://rstudio-education.github.io/hopr/environments.html
##  Hands-On Programming with R
##  Garrett Grolemund
##
##
##  SCRATCH WORK,  eventually will put in jimTools:: as cheat sheet.
##
##
# char[] of all env,  .GlobalEnv up to package:base  
# EmptyEnv()?
search()

## n > 0 returns <e> plus attrs 
as.environment(13)

## no n=0, but n=-1 refers to calling env (if inside function)
as.environment(-1)

## Example1
f  <- function() {
  as.environment(-1)
}
f()


## Example2
f  <- function() {
  function() {
    as.environment(-1)
  }
}

g  <- f()
g()


# Example 3
# =============
h  <- function(){
  as.environment(-1)}

f  <- function() h()
f()  # returns env where h is called (ie inside f)
# 
#
#
## Chapter 8.2
## <e>  <- parent.env(<e>)

# EX  parent of current environment, which is Glboal
e  <- parent.env(environment())
e

# EX: same
e  <- parent.env(globalenv())
e

## in my setup parent env of package:rlang 12 is package:devtools (see search)
e  <- parent.env(as.environment(12))
e
## SAME
e  <- parent.env(as.environment("package:rlang"))
e

## Special named environemnts
globalenv()
baseenv()
emptyenv()


## Objects in <e>
ls(environment())
ls(as.environment("package:rlang"))   # ~468 objects!

# a bit more info
ls.str(environment())
if (FALSE) {
  ls.str(as.environment("package:rlang"))   # 
}


## assign object to <e> (advantage:  easier to program assign)
assign("x", "hello", envir = globalenv())
ls(globalenv())

# shortcut  or e$y  <- 10
y  <- 10
ls(globalenv())


## Chapter 8.2.1
## Purpose of environments?   
## R can find objects, store objects, evaluation FUN
##
## R works with 1 (one) enviroment at a time
## Typically this environment is GlobalEnv
##

# Find the active environment
e  <- environment()
e


## SCOPE
## R finds objects using SCOPING RULES
## 1.   Search by object name, staring in active env
## 2.   (Typically this is command line)
## 3.   If object not found in active env, proceed upward to parent.env()
## 4.   If not found by emptyenv, returns not found.
##
##
##

## Evaluating (ie running) a  FUN
## R creates a temporary env, think scratch work, to hold objects created.
## Solves a BIG problem:  does not overwrite variable in Globalenv or any
## other.
##
## This is called RUNTIME ENV.
##
## SECTION 8.5
## When FUN completes, R returns to CALLING ENV with value from FUN.
##
show_env <- function(){
  list(ran.in = environment(),     # temporary (active, or runtime) env
    parent = parent.env(environment()),# parent 
    objects = ls.str(environment())
  )
}
show_env()


## Where is function created, defined?
environment(show_env)
environment(here)
environment(sin)   # sin is primitive, no origin env
environment(abort)
environment(nvimR.chunk)
environment(install.packages)
environment(ls)

## From Example2, above:

f  <- function() {
  function() {
    show_env()
#    as.environment(-1)
  }
}

g  <- f()    # origin env?  runtime of f
g()          # calling env? Global

environment(f)    # in R_GlobalEnv
environment(g)    # defined in  runtime env of f()

# Can reassign   .... something not right
environment(g)   <- baseenv() 
environment(g)
g()

show_env(cat("hello"))


## show_env - tools
```{r show_env}
show_env <- function(){
  list(ran.in = environment(),     # temporary (active, or runtime) env
    parent = parent.env(environment()),# parent 
    objects = ls.str(environment())
  )
}
show_env()
```

```{r example}
# call env = global
# origin env = global
# runtime env = 0x....
#
# enlcosing env =
# binding env = 
#
x  <- 1
f  <- function() {
  show_env()
}
environment(f)
f()
```

```{r step2}
# function g
# call env  = global
# origin env = runtime of f
# runtime env  = child of f's runtime

f  <- function() {
  x  <- 10
  y  <- environment()
  function() { 
    list(x = x, "runtime(f)" = y, show_env(), "env(g)" = environment(g))
  }
}


f
g  <- f()
g
g()
environment(g)
