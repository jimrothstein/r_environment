
	 vim:linebreak:nowrap:nospell:cul tw=78 fo=tqlnr foldcolumn=3 
--- 
# Spaces, no Tabs
title: Template for .Rmd 
date: "`r paste('last updated', 
    format(lubridate::now(), '%H:%M, %d %B %Y'))`"
output: 
  pdf_document: 
    latex_engine: xelatex
toc: TRUE 
toc_depth:  1 
fontsize: 12pt 
geometry: margin=0.5in,top=0.25in 
TAGS: formals, args, rlang::enexprs, pairlist
---

```{r setup, include=FALSE		}
knitr::opts_chunk$set(echo = TRUE,
                      comment = "      ##",
                      error = TRUE,
                      collapse = TRUE)
```


```{r library, include=FALSE		}
library(jimTools)
``` 

formals return `pairlist`, with name and value
```{r warmup}
f  <- function(x = 1 ) x

formals(f)  # pairlist, not regular list
typeof(formals(f))
environment(f)

# compare
g  <- function(x ) x
formals(g)
```
args, for interactive use
```{r args}
args(f)
args(g)
```

names of args (not a pairlist)
```{r names}
names(formals(f)) # vector 
names(formals(g))
```

extract iniital values for formals
```{r pairlist}
p  <- formals(f)
p
p[["x"]]

```

inside the function, how can query values of all the formals?
```{r inside}
f  <- function(x = 1, y = 100){
   x  <- 3
  l  <- names(formals(f) )  # character vector of arg nmaes 
  lapply(l, `[`)
}
a  <- list(x=1, y=2)
lapply(a, `[`)
 r  <- f( 2)
typeof(r)
r


```

enexprs
```{r user_args}

g  <- function(x, ...) {
  rlang::enexprs( ... )
}

x  <- "test"
g(x, b="hello")
g(x, a="hello", b="hi", c="good day", d="good evening")
l  <- g(x,  b="hi", c="good day", d="good evening")
names(l)

str(l)
```

```{r begin}
# return list of non-NULL 
f  <-  function(x=NULL, y = NULL, z = NULL, w = NULL, v = NULL) {
  l  <- formals(f)
   lapply(l, is.null)
}

# WORKS
f  <-  function(x=NULL, y = NULL, z = NULL, w = NULL, v = NULL) {
  rlang::enexprs(x,y)
}

# chr[] names of all args
f(x = 3, y=2)


# FAILS, errors
g  <-  function(x=NULL, y = NULL, z = NULL, w = NULL, v = NULL) {
  rlang::enexprs(...)
}
g(x=2)
```


```{r composite}
g   <- function(x) x
f  <- function(x) paste0("hello"," ", x)

f(g("jim"))
f(g)("jim")  # erroo
(f(g))("jim") #error
```

***

```{r knit_exit()} 
knitr::knit_exit()
```

/newpage

```{r render, eval=FALSE	} 
file <- ""
file  <- basename(file)
dir <- "rmd"

jimTools::ren_pdf(file,dir)
jimTools::ren_github(file, dir)
```
