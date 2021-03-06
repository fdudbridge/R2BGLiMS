#' Infers Bayes factors for the different possible model sizes from a Reversible Jump Results object.
#' @export
#' @title Infer credible sets of predictors
#' @name ModelSizeBayesFactors
#' @inheritParams ManhattanPlot
#' @return List of dimension Bayes Factors
#' @author Tokhir Dadaev and Paul Newcombe
ModelSizeBayesFactors <- function(
  results) {
  
  ######################
  ### --- Errors --- ###
  ######################
  
  ### Error checks
  
	if (results@enumerate.up.to.dim==0) {
	  #########################
	  # --- MCMC was done --- #
	  #########################
	  dim.bf.table.partitions <- list()
	  for (partition in length(results@model.space.priors)) {
	    if (results@bglims.arguments$ModelSpacePriorFamily=="Poisson") {
	      prior.proportion <- results@model.space.priors[[partition]]$Rate
	      P <- length(results@model.space.priors[[partition]]$Variables)
	    } else if (results@bglims.arguments$ModelSpacePriorFamily=="BetaBinomial") {
	      prior.proportion <- results@model.space.priors[[partition]]$a/(results@model.space.priors[[partition]]$a+results@model.space.priors[[partition]]$b)
	      P <- length(results@model.space.priors[[partition]]$Variables)
	    }
	    
	    # Figure out prior probs
	    prior.probs.dims <- sapply(1:P, function(i) prior.proportion ^ i * (1 - prior.proportion) ^ (P - i) * choose(P, i) )
	    max.dim.calculable <- max(which(prior.probs.dims>0)) # Stop when prior prob becomes so small to calculate
	    prior.probs.dims <- prior.probs.dims[1:max.dim.calculable]
	    prior.probs.ge.dims <- rev(cumsum(rev(prior.probs.dims)))

	    # Figure out posterior probs
	    dim.each.iteration <- rowSums(results@mcmc.output[,results@model.space.priors[[partition]]$Variables] != 0)
	    n.saved.its <- length(dim.each.iteration)
	    posterior.probs.ge.dims <- sapply(1:max.dim.calculable, function(i) sum(dim.each.iteration>=i)/n.saved.its)

	    # Calculate the Bayes Factors
	    bfs.dims <-
	      sapply(1:max.dim.calculable, function(i){
	        post.prob <- posterior.probs.ge.dims[i]
	        post.odds <- post.prob/(1-post.prob)
	        
	        prior.prob <- prior.probs.ge.dims[i]
	        prior.odds <- prior.prob/(1-prior.prob)
	        
	        post.odds/prior.odds
	      })
	    
	    dim.res.table <- rbind("PriorProb"=prior.probs.ge.dims,"PostProb"=posterior.probs.ge.dims,"BF"=bfs.dims)
	    colnames(dim.res.table) <- paste("BF >=", 1:max.dim.calculable, " Covariates",sep="")
	    
	    dim.bf.table.partitions[[partition]] <- dim.res.table
	  }
	} else {
	  ################################
	  # --- Enmueration was done --- #
	  ################################
	  
	  if (results@n.covariate.blocks.for.jam > 1) stop("So far only implemented for enumeration in one block")
	  if (length(results@model.space.priors) > 1) stop("So far only implemented for enumeration with one model space partition")
	  
	  if (results@bglims.arguments$ModelSpacePriorFamily=="Poisson") {
	    prior.proportion <- results@model.space.priors[[1]]$Rate
	    P <- length(results@model.space.priors[[1]]$Variables)
	  } else if (results@bglims.arguments$ModelSpacePriorFamily=="BetaBinomial") {
	    prior.proportion <- results@model.space.priors[[1]]$a/(results@model.space.priors[[1]]$a+results@model.space.priors[[1]]$b)
	    P <- length(results@model.space.priors[[1]]$Variables)
	  }
	  max.dim <- results@enumerate.up.to.dim
	  
	  # Figure out prior probs
	  prior.probs.dims <- sapply(0:max.dim, function(i) prior.proportion ^ i * (1 - prior.proportion) ^ (P - i) * choose(P, i) )
	  prior.probs.dims <- prior.probs.dims/sum(prior.probs.dims) # Normalise due to truncation
	  prior.probs.dims <- prior.probs.dims[-1] # Remove 0 dimension
	  prior.probs.ge.dims <- rev(cumsum(rev(prior.probs.dims)))
	  
	  # Figure out posterior probs
	  posterior.probs.ge.dims <- results@enumerated.posterior.inference$dim.probs
	  
	  # Calculate the Bayes Factors
	  bfs.dims <-
	    sapply(1:max.dim, function(i){
	      post.prob <- posterior.probs.ge.dims[i]
	      post.odds <- post.prob/(1-post.prob)
	      
	      prior.prob <- prior.probs.ge.dims[i]
	      prior.odds <- prior.prob/(1-prior.prob)
	      
	      post.odds/prior.odds
	    })
	  
	  dim.res.table <- rbind("PriorProb"=prior.probs.ge.dims,"PostProb"=posterior.probs.ge.dims,"BF"=bfs.dims)
	  colnames(dim.res.table) <- paste("BF >=", 1:max.dim, " Covariates",sep="")
	  dim.bf.table.partitions <- list(dim.res.table)
	}
  
  # --- Return
	return(dim.bf.table.partitions)
}
