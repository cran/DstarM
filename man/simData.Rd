% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simData.R
\name{simData}
\alias{simData}
\title{Simulate data from a given density function via multinomial sampling}
\usage{
simData(
  n,
  pars,
  tt,
  pdfND,
  fun.density = Voss.density,
  args.density = list(prec = 3),
  npars = 5,
  return.pdf = FALSE,
  normalizePdfs = TRUE
)
}
\arguments{
\item{n}{Number of observations to be sampled}

\item{pars}{Parameter values for the density function to be evaluated with. \code{length(pars)} must be a multiple of npars.}

\item{tt}{time grid on which the density function will be evaluated. Responses not in this time grid cannot appear.}

\item{pdfND}{either a vector of length tt specifying the nondecision density for all condition-response pairs,
or a matrix where columns corresponds to the nondecision densities of condition-response pairs. Supplying \code{NULL} implies no nondecision distribution.}

\item{fun.density}{Density function to use.}

\item{args.density}{Additional arguments to be passed to \code{fun.density}, aside from \code{tt}, \code{pars}, and a boundary argument ('upper' or 'lower')}

\item{npars}{Number of parameters \code{fun.density} must be evaluated with. If \code{length(pars) > npars} each \code{npars} values in \code{pars} will be seen as the parameter values of a condition.}

\item{return.pdf}{Logical, if TRUE \code{genData} returns a list containing the probability density function used and the data, if FALSE \code{genData} returns a dataframe with simulated data.}

\item{normalizePdfs}{Logical, should the pdf of the nondecision distribution be normalized?}
}
\value{
A sorted dataframe where rows represent trials. It contains: a column named rt
containing reaction times in seconds, a column named response containing either
response option lower or upper, and a column named condition indicating which
condition a trials belongs to. If \code{return.pdf} is TRUE it returns a list where the
first element is the sorted dataframe, the second through the fifth elements are lists
that contain densities used for simulating data.
}
\description{
Simulate data from a given density function via multinomial sampling
}
\details{
Simulate data via multinomial sampling.
The response options to sample from should be provided in \code{tt}.
The number of conditions is defined as \code{length(pars) / npars}.
}
\examples{
tt = seq(0, 5, .01)
pdfND = dbeta(tt, 10, 30)
n = 100
pars = c(1, 2, .5, .5, .5)
dat = simData(n, pars, tt, pdfND)
head(dat)
}
