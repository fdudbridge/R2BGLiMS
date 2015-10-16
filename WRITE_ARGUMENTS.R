default.arguments <- list(
  "AlphaPriorMu" = 0,
  "AlphaPriorSd" = 1000,
  "WhichBetaPrecisionPrior" = 1,
  "BetaSigma_UnifArg1" = 0.01,
  "BetaSigma_UnifArg2" = 2,
  "BetaPrecision_GammaPrior_Shape" = 0.001,
  "BetaPrecision_GammaPrior_Scale" = 0.001,
  "WeibullScalePrior_GammaArg1" = 1,
  "WeibullScalePrior_GammaArg2" = 0.001,
  "WhichGaussianPrecisionPrior" = 0,
  "GaussianResidualPrior_UnifArg1" = 0,
  "GaussianResidualPrior_UnifArg2" = 2,
  "GaussianResidualVarianceInvGammaPrior_a" = 0.01,
  "GaussianResidualVarianceInvGammaPrior_b" = 0.01,
  "Alpha_Initial_Value" =0,
  "Beta_Initial_Value" =0,
  "BetaPriorSd_Initial_Value" =0.1,
  "WeibullScale_Initial_Value" =1,
  "GaussianResidual_Initial_Value" =1,    
  "Adaption_Bin" = 100,
  "Adaption_Iterations" = 100000,
  "Delete_Move_Probability" = 0.2,
  "Add_Move_Probability" =0.2,
  "Swap_Move_Probability" =0.2,    
  "Alpha_Initial_Proposal_Sd" =0.1,
  "Beta_Initial_Proposal_Sd" =0.05,
  "Beta_Prec_Initial_Proposal_Sd" =0.05,
  "WeibullScale_Initial_ProposalSd" =0.1,
  "LogGaussianResidual_Initial_ProposalSd" =0.01,
  "Tau_Initial_ProposalSd" = 0.05,
  "BetaAdd_Initial_Proposal_Sd" =0.1,
  "BetaSwap_Initial_Proposal_Sd" =0.001,
  "Alt_Saturated_Initial_Model" =0,
  "Alt_Alpha_Initial_Value" =1,
  "Alt_Beta_Initial_Value" =1,
  "Alt_BetaPriorSd_Initial_Value" =0.2,
  "Alt_WeibullScale_Initial_Value" =1.25
  )
save(default.arguments,
     file="~/Dropbox/Work Projects/R Packages/R2BGLiMS/data/DefaultArguments.rda")