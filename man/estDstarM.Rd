% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estDstarM.R
\name{estDstarM}
\alias{estDstarM}
\title{Do a D*M analysis}
\usage{
estDstarM(
  formula = NULL,
  data,
  tt,
  restr = NULL,
  fixed = list(),
  lower,
  upper,
  Optim = list(),
  DstarM = TRUE,
  SE = 0,
  oscPdf = TRUE,
  splits = rep(0L, (ncondition)),
  forceRestriction = TRUE,
  mg = NULL,
  h = 1,
  pars,
  fun.density = Voss.density,
  args.density = list(),
  fun.dist = chisq,
  args.dist = list(tt = tt),
  verbose = 1L,
  useRcpp = TRUE
)
}
\arguments{
\item{formula}{A formula object of the form:
\code{binary response ~ reaction time + condition1 * condition2 * ... conditionN}.}

\item{data}{A dataframe for looking up data specified in formula.
For backwards compatibility this can also be with: a column named \code{rt} containing response times in ms,
a column named \code{response} containing at most 2 response options, and an
optional column named \code{condition} containing a numeric index as to which conditions
observations belong.}

\item{tt}{A time grid on which the density function will be evaluated.
Should be larger than the highest observed reaction time.}

\item{restr}{A restriction matrix where each column depicts one condition.
The number of rows should match the number of parameters (and be equal to the length of lower).
The contents of \code{restr} should be numbers, identical numbers means that these parameters
(either within or between condition) will be constrained. Different numbers means parameters
will not be constrained.}

\item{fixed}{A matrix that allows for fixing parameters to certain values.}

\item{lower}{Should be a vector containing lower bounds for each parameter.
Has a default if \code{fun.density == Voss.density}.}

\item{upper}{Should be a vector containing upper bounds for each parameter.
Has a default if \code{fun.density == Voss.density}.}

\item{Optim}{a named list with identical arguments to \code{\link[DEoptim]{DEoptim.control}}.
In addition, if \code{verbose} == TRUE \code{Optim$steptol} can be a vector, i.e.
\code{c(200, 50, 10)} means: Do 200 iterations then check for convergence, do 50
iterations then check for convergence, check every 10 iterations for convergence until
itermax is reached. Defaults to \code{Optim = list(reltol = 1e-6, itermax = 1e3,
steptol = 50, CR = .9, trace = 0, parallelType = 0)}.}

\item{DstarM}{If TRUE a D*M analysis is done, otherwise the Chi square distance
between data and model is minimized.}

\item{SE}{positive value, how many standard error to add to the variance to relax
the variance restriction a bit.}

\item{oscPdf}{Logical, if TRUE check for oscillations in calculated densities and
remove densities with oscillations.}

\item{splits}{Numeric vector determining which conditions have an equal nondecision density.
Identical values in two positions indicate that the conditions corresponding to the indices
of those values have an identical nondecision distribution.}

\item{forceRestriction}{if TRUE the variance restriction is enforced.}

\item{mg}{Supply a data density, useful if a uniform kernel approximation does not suffice.
Take care that densities of response categories within conditions are degenerate and therefore integrate to the proportion a category was observed (and not to 1).}

\item{h}{bandwidth of a uniform kernel used to generate data based densities.}

\item{pars}{Optional parameter vector to supply if one wishes to evaluate the objective
function in a given parameter vector. Only used if \code{itermax} equal zero.}

\item{fun.density}{Function used to calculate densities. See details.}

\item{args.density}{A names list containing additional arguments to be send to fun.density.}

\item{fun.dist}{Function used to calculate distances between densities.
Defaults to a chi-square distance.}

\item{args.dist}{A named list containing additional arguments to be send to fun.dist.}

\item{verbose}{Numeric, should intermediate output be printed? Defaults to 1, higher values result in more progress output.
Estimation will speed up if set to 0. If set to TRUE, \code{Optim$trace} will be
forced to 0, hereby disabling the build in printing of \code{DEoptim}. To enable the
printing of \code{DEoptim}, set \code{verbose} to 0 and specify \code{Optim$trace}.
\code{Optim}. If set to 1, ETA refers to the expected maximum time until completion (when the iterations limit is reached).}

\item{useRcpp}{Logical, setting this to true will make the objective function use an Rcpp implementation
of \code{Voss.density} with the distance function \code{chisq}. This gains speed at the cost of flexibility.}
}
\value{
Returns a list of class \code{DstarM.fitD} that contains:
\item{Bestvals}{Named numeric vector. Contains the best parameter estimates.}
\item{fixed}{Numeric vector. Contains the best parameter estimates.}
\item{GlobalOptimizer}{List. All output from the call to \code{\link[DEoptim]{DEoptim}}}
\item{Debug}{List. contains the number of DEoptim iterations, the number of function evaluation of the objective function, and the maximum number of iterations.}
\item{note}{String. A possible note that is used for summary purposes}
\item{tt}{Numeric vector. Contains the time grid used.}
\item{g.hat}{Numeric matrix. Named columns represent the (possibly smoothed) densities of the data distribution of each condition-response pair.}
\item{modelDist}{Numeric matrix. Named columns represent the densities of the model evaluated at grid \code{tt} with parameters \code{Bestvals}.}
\item{ncondition}{Numeric scalar. The number of conditions}
\item{var.data}{Numeric vector. The variance of each condition-response pair. There are as many values as hypothesized nondecision densities.}
\item{var.m}{Numeric vector. The variance of the model distributions. There are as many values as hypothesized nondecision densities.}
\item{restr.mat}{Numeric matrix. Contains the restrictions used.}
\item{splits}{Numeric vector. Equal to the input argument with the same name.}
\item{n}{Numeric scalar. The total number of observations.}
\item{DstarM}{Logical. Equal to the input argument with the same name.}
\item{fun.density}{Function. Equal to the input argument with the same name.}
\item{fun.dist}{Function. Equal to the input argument with the same name.}
\item{h}{Scalar. Equal to the input argument with the same name.}
\item{args.density}{Named list. Equal to the input argument with the same name.}
\item{args.dist}{Named list. Equal to the input argument with the same name.}
}
\description{
Do a D*M analysis
}
\details{
Response options will be alphabetically sorted and the first response option will be
treated as the 'lower' option. This means that if the observed proportion of the first
response options is higher, the drift speed will most likely be negative.

\code{fun.density} allows a user to specify a custom density function. This function must (at least) take the following arguments:
\code{t}: a vector specifying at which time points to calculate the density
\code{pars}: a parameter vector
\code{boundary}: character 'upper' or 'lower' specifying for which response option the density will be calculated.
\code{DstarM}: Logical, if TRUE the density should not describe the nondecision density, if FALSE it should describe the nondecision density.
Any additional arguments can be passed to \code{fun.density} via the argument \code{args.density}.
If one intends to use a custom density function it is recommended to test the function first with \code{\link{testFun}}.
When specifying a custom density function it is probably also necessary to change the lower and upper bounds of the parameter space.

For purposes of speed, the function can be run in parallel by providing the argument \code{Optim = list(parallelType = 1)}.
See \code{\link[DEoptim]{DEoptim.control}} for details. Also, for Ratcliff models the objective function has been rewritten in Rcpp.
This limits some functionality but does result in a faster estimation. Usage of Rcpp can be enabled via \code{useRcpp = TRUE}.

When verbose is set to 1, the ETA is an estimated of the time it takes to execute ALL iterations.
Convergence can (and is usually) reached before then.
}
\examples{

# simulate data with three stimuli of different difficulty.
# this implies different drift rates across conditions.
# define a time grid. A more reasonable stepsize is .01; this is just for speed.
tt = seq(0, 5, .1)
pars = c(.8, 2, .5, .5, .5, # condition 1
        .8, 3, .5, .5, .5,  # condition 2
        .8, 4, .5, .5, .5)  # condition 3
pdfND = dbeta(tt, 10, 30)
# simulate data
data = simData(n = 3e3, pars = pars, tt = tt, pdfND = pdfND)
# define restriction matrix
restr = matrix(1:5, 5, 3)
restr[2, 2:3] = 6:7 # allow drift rates to differ
# fix variance parameters
fixed = matrix(c('sz1', .5, 'sv1', .5), 2, 2)
\dontrun{
# Run D*M analysis
res = estDstarM(data = data, tt = tt, restr = restr, fixed = fixed)
coef(res)
summary(res)
}
}
