## Referee A

We thank the referee for the thoughtful review of our work and for raising important points, addressed below, which we think helped us improve the paper.

- *The claim is probably true, but unfortunately it does not describe a generic situation, because it is very hard to imagine that the exponents alpha, beta, gamma used in the model are identical for all populations. Perhaps the model would be more interesting if it included a spectrum of different exponents, described, for example, by a probabilistic law.*

We agree that indeed a spectrum of different exponents is probably more realistic, and thank the reviewer for pointing that out.

We consider now the case in which the exponents are not identical for every variable $x_i$ but instead we have them from Gaussian distributions: $\alpha_i\sim\mathcal N(\alpha,\sigma_e)$, $\beta_i\sim\mathcal N(\beta,\sigma_e)$ and $\gamma_i\sim\mathcal N(\gamma,\sigma_e)$, respectively with mean $\alpha$, $\beta$ and $\gamma$, and, for simplicity, all with the same standard deviation $\sigma_e$. 

We now added a Supplemental Material document where report results of simulations showing that our results are robust as long as $\sigma_e$ is small enough that $\displaystyle{\min_i\beta_i>\max_i\alpha_i}$. We also added a paragraph in the main text where we discuss this point.

- *The way of writing the matrix elements in Equations (7) is somewhat confusing. For clarity, the Kronecker delta can be used on the right side of these equations.*

We modified Equations (7) accordingly.

- *The mean field equations depend on the expected values of <x_^\gamma> and <x_^{2\gamma}>. The self-consistency condition requires that the probability distribution (12) has exactly the same expected values. This should be discussed in detail.*

We agree with the referee that the discussion about the expected values and self-consistency conditions needed clarifications. 

In some cases, for example, $\alpha=1, \beta=3, \gamma=1$, both expectations converge to finite values and we can safely compute the self-consistency equations. However in potential cases of interest, and in the example case $\alpha=1, \beta=3/2, \gamma=1$ characterized by a distribution with a power-law tail with exponent $-3/2$, the moments diverge. We now modified the discussion removing the Gaussian approximation and considering the introduction of a cut-off. The idea behind this cut-off is described in the main text and in the Supplemental Material.

## Referee B

We thank the referee for their thorough and critical review of our work. We address each of the comments below point by point. We believe the results of our paper are more transparent thanks to these modifications.

- *Modelling Framework Justification:*
    
     *The rationale behind the proposed generalization of the GLV model is claimed to be "natural" based on physical and biological grounds, specifically using power laws. Nevertheless, the literature extensively demonstrates species abundance growth being well-described by logistic equations or oscillatory predator-prey equations, that indeed are linear (except for the carrying capacity term). The justifications provided are weak, with the provided examples failing to convincingly represent the complex dynamics of natural systems, such as forest biomass distribution. If we think to a forest there are various heights of trees, and in general the biomass in not uniformly distributed, and thus also the growth is not necessary constrained by the surface. The sublinear scaling of the “production function”, f, if this is really the right conclusion based on the references of the manuscript, must be the result of a cooperative behavior of the interacting system and as such it should not appear as hand-added like the authors do. Furthermore, in reference 27 the sublinear scaling with k=3/4 refers to the scaling of the single individual growth rather than to a community.*

We recently published a separate paper (cited as Ref. [17]) to outline in some detail the ecological motivations and consequences of competitive models with sublinear production. The goal of the present letter is different. Following Refs. [18] and [19], we show in a minimal setting (and for an audience of physicists) the existence of the two opposite complexity-stability relationships in disordered dynamical systems. We have reword

We are aware that reference [27] refers to the scaling of single individuals. We now mention that explicitly.

- *Feasibility Condition Neglected:*

    *The authors do not seem to consider the condition for the feasibility of the fixed points (x\* >= 0), which is critical. This oversight, especially evident in Equations 11 and 12, i.e., Eq. 12 or its Gaussian approximation are normalized from 0 or from -infty to infty? I think this is a very relevant issue calling into question the appropriateness of the results.*

We thank the referee for raising this point.
We have now specified that the distribution in Eq.(11) is defined from zero to infinity and that in the specific case we analyze the system is always feasible. This happens because, given that $\alpha<\beta$, at low enough density each degree of freedom effectively decouples from the others and only feels self-interactions and therefore never crosses zero.

- *Lack of Proper Scaling:*
    
    *There is no proper scaling of the interactions, so the thermodynamic limit is not well defined. And this is not discussed or compared with other models in the literature applying similar disputable choice (see E Mallmin, A Traulsen, S De Monte - arXiv preprint arXiv:2306.11031, 2023). Relatedly, the comparison with GLV with quenched disorder (e.g. “The properties of large random dynamical systems is often portrayed in the ( sigma sqrt(N) , mu N ) plane [25] is not appropriate as such model scales the interactions strengths with the system size.*

This is a delicate point and we thank the referee for raising it. This gives us the opportunity to elaborate more on the choice of not scaling the interactions. 

As also discussed in reference [25] (end of "I. MODEL DEFINITION"), the choice of scaling or not the interaction depends on the ecological setting of interest. 
We believe that it is appropriate to fix the strength and heterogeneity of the interaction ($mean(A)=\mu$ and $var(A)=\sigma^2$) if our goal is to study the effects of changes in the number of degrees of freedom.
In this setting, while the full limit in which $N\to\infty$ leads to the homogeneous interaction case with $x^*\to0$ due to competitive pressure, the cavity approximation does a good job at describing the empirical distributions obtained from simulations as long as $\sigma\sqrt{N}$ is not negligible with respect to $\mu N$.

We now discuss this and point out that it amounts to consider a strong-interactions regime and compare with the reference mentioned by the referee (E Mallmin, A Traulsen, S De Monte *PNAS* 2024, now reference [35] in the manuscript) for an ecological example in which this choice is made to study chaotic turnover of species with broad abundance distributions.

- *Gaussian Approximation:*

    *The justification for employing a Gaussian approximation is unclear, given that Equation 12 should be solved self-consistently. Ecologically, Gaussian species abundance distributions (SADs) are not meaningful due to the prevalence of heavy-tailed SADs in natural ecosystems.*

We thank the referee for this important comment, we now removed the Gaussian approximation in the discussion and clarified how to treat the case in which self-consistently computing the moment in Equation (12) can be problematic, as explained above in the answers to referee A.

- *Homogenous Case and Stability:*
     *The manuscript concludes that stability requires stronger self-interactions than cross-interactions when alpha equals beta. While this is true that self-interactions promote stability also for the Lotka-Volterra model, any negative mean species interaction (indicating mutualism) in the homogeneous case leads to instability, irrespective of system size. Thus, comparing this to the GLV model seems a stretch.*

We are grateful to the referee for this comment, it helps to clarify the scope of our work. We have now specified everywhere in the manuscript, including Abstract, Introduction and Discussion, that we compare our results to the *competitive* Lotka-Volterra model and in general that our results are relevant for predominantly competitive systems.

- *Notation:*

     *Using S instead of N for species richness would align better with ecological conventions.*

We decided to keep $N$ to indicate the number of degrees of freedom because our goal is not to align with ecological literature, rather we would like to speak to the community of scientists working in complex systems. We made this choice in the first place to align with Robert May notation in reference [1].

- *Discussion Quality:*

    *Given the issues raised, the discussion section of the manuscript needs substantial improvement to convincingly argue the paper's contributions to the field. In light of these concerns, before the authors submit their manuscript elsewhere, I recommend to undertake significant revisions to address the weaknesses in their modelling framework, the rationale behind their approach, and the ecological implications of their findings*

We are thankful for the critical review overall. We extended the discussion and improved the paper in different aspects following the suggestions of the referee.