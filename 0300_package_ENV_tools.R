TAGS:  namespace, rlang, environment
# 065A_env_pkg_tools.R

# PURPOSE:  tools for env, probing pkg environment

##-----------------------------------------
# Where is package installed? (pkgload:: part of devtools::)
pkgload::inst("ggplot2") #/home/jim/R/x86...-library/3.6/ggplot2
pkgload::inst("base")   #/usr/lib/R/library/base

##-----------------------------------------
##  IS PACKAGE LOADED & ATTACHED?

# env (Ref: Adv R v2  Chapter 7.4)
# each is entry is PARENT of prior
base::search()
#
# insert env, single ":"
base::objects("package:stats")

# OR, a bit easier to read
rlang::search_envs()

# library(ggplot).  As last to be installed, it becomes parent of 'workspace'
library(ggplot2)
rlang::search_envs()

library(magrittr)	# now this will be parent of 'workspace'
rlang::search_envs()

##-------------------------------------
## NAMESPACES - See Ch 7.4.3


## base:exists() ?


---
title: "`r knitr::current_input()`"
date: "`r paste('last updated', 
    format(lubridate::now(), ' %d %B %Y'))`"
output:   
  html_document:  
        code_folding: show
        toc: true 
        toc_depth: 2
        toc_float: true
  pdf_document:   
    latex_engine: xelatex  
    toc: true
    toc_depth:  2   
    fontsize: 11pt   
    geometry: margin=0.5in,top=0.25in   
---


##  Code to probe namespace
REF: R-pkg  v2 
NAMESPACE
chapter 11


```{r setup, include=FALSE		}
knitr::opts_chunk$set(echo = TRUE,
                      comment = "      ##",
                      error = TRUE,
                      collapse = FALSE   ) # easier to read
```


```{r library, include=FALSE		}
file  <- knitr::current_input() 
``` 

### search path (shows attached pkgs)
  * before 
  * after loading a package

```{r search}
# compare search() before/after adding package.
old  <- search()
old

# :: loads pkg testthat (not attach)
testthat::expect_equal(1,1)

# no change
setdiff(search(),old)

# load AND attach
library(testthat)
expect_equal(1,1)
new <- search()
new
setdiff(new, old)   # observe "package:testthat"
```
```{r namespaces}
# show loaded 
loadedNamespaces()

# show loadd AND attached
search()
```


### To load/unload namespace
*  library("pkg") # loads and attaches
*  loadNamespace(pkg) # does NOT attach
```{r load_namespace }

# setdiff(x, y)  # lists elements in x, but not in y

x  <- c(0,1) 
y  <- c(0,1,2)
setdiff(x, y)  # no elements in x, but not in y
setdiff(y, x)

old  <- loadedNamespaces()
old

# load, NOT attach (Usually not done this way, library() will load and attach)
loadNamespace("jimTools")
new  <- loadedNamespaces()
new
base::setdiff(new, old)

# unload
unloadNamespace("jimTools")
loadedNamespaces()

setdiff(old, loadedNamespaces())




```

### detach pkg
*  default, leaves loaded
*  use unload=TRUE to detach & unload
```{r detach}

search()
library("fs")
old  <- search()

detach("package:fs", unload = FALSE )
setdiff(old, search())
```

NEXT:
```{r detach2}

# ------- detach #2 ----------
# if ( <cond>, TRUE, FALSE )
check <- function(pkg) 
ifelse((pkg %in% search()), paste0(pkg," is in search"), paste0(pkg, " is NOT in search"))


pkg = "package:fs"
check(pkg)
loadedNamespaces()

library("fs")
check(pkg)
loadedNamespaces()

if("package:fs" %in% search()) detach("package:fs", unload=FALSE)
check(pkg)

check(pkg)
unloadNamespace(pkg)
check(pkg)
```

### HOOKS
.onLoad
     .onLoad(libname, pkgname)
     .onAttach(libname, pkgname)
     .onUnload(libpath)
     .onDetach(libpath)
     .Last.lib(libpath)
```{r hooks, eval = FALSE }

.onLoad  <- function(libname, pkgname)	message ("loading")

.onLoad(.libPaths(), "ggplot2")


# Loads  (returns t/f) does NOT attach
(requireNamespace("ggplot2"))
search()   # no change

```

```{r render, eval=FALSE, include=FALSE 	} 
# TODO:  file is found when knitr runs (see above)

# file must be of form:
# dir/name_of_this_file    where dir is relative to project root

file  <- here("", "")
file  <- "env_code/0088_env_namespace.Rmd"

# in general, pdf will look nicer
rmarkdown::render(file,
                  #output_format = "pdf_document",
                  output_format = "html_document",
                  output_file = "~/Downloads/print_and_delete/out")
```
