# Referee reports

## Report of Referee A -- LN17679/Mazzarisi

The authors discuss the stability properties of a system of
first-order differential equations describing the evolution of coupled
populations in an ecosystem. The model is intended to show that May's
prediction that large complex systems cannot be stable is not a
general property of such systems. The model is actually a modification
of the original model, considered by R.M. May, with the difference
that the authors replace linear functions with power functions in
population dynamics. They show that for a certain combination of power
function exponents, the system becomes more stable as its size
increases, unlike the original May model.

The claim is probably true, but unfortunately it does not describe a
generic situation, because it is very hard to imagine that the
exponents alpha, beta, gamma used in the model are identical for all
populations. Perhaps the model would be more interesting if it
included a spectrum of different exponents, described, for example, by
a probabilistic law.

Minor remarks:

The way of writing the matrix elements in Equations (7) is somewhat
confusing. For clarity, the Kronecker delta can be used on the right
side of these equations.

The mean field equations depend on the expected values of <x_*^\gamma>
and <x_*^{2\gamma}>. The self-consistency condition requires that the
probability distribution (12) has exactly the same expected values.
This should be discussed in detail.

In summary, I do not think that the paper meets PRL criteria. However,
I would recommend the article for submission as a regular article to
Physical Review E, after the authors have softened their conclusions
and improved the discussion of the mean-field approximation.

---

## Report of Referee B -- LN17679/Mazzarisi

Dear editor,
I have reviewed the manuscript entitled "Beyond May: Complexity-stability relationships in
disordered dynamical systems" intended for publication in Physical Review Letters. This study
seeks to address the well-known May's stability-complexity conundrum by incorporating

recent developments in random matrix theory into a non-linear generalization of the Lotka-
Volterra (GLV) model.

Summary:

The authors challenge Robert May's conclusion that large, complex systems inherently lack
stability by using a non-linear generalization of the GLV model, incorporating power-law
functions into the interactions between species and species growth rate. Their findings
suggest that the instability in complex systems as posited by May is not a universal
characteristic but rather specific to a subclass of weakly cross-regulated systems.
General Comments:
The manuscript could be of interest to researchers focusing on ecological systems, especially
those applying disordered system approaches. However, the modelling framework and
ecological implications presented in the paper are predicated on assumptions that I find
somewhat tenuous. The authors' arguments do not convincingly justify the generalization of
the GLV model, as well as the main ecological finding is quite consequential given the model’s
hypotheses. Moreover, I have few major technical and conceptual concerns that from my
point of view should be fixed before publication in any journal.
The relevance of the work appears confined to a niche.

#### Major Concerns:

Modelling Framework Justification:

• The rationale behind the proposed generalization of the GLV model is claimed to be
"natural" based on physical and biological grounds, specifically using power laws.
Nevertheless, the literature extensively demonstrates species abundance growth
being well-described by logistic equations or oscillatory predator-prey equations, that
indeed are linear (except for the carrying capacity term). The justifications provided
are weak, with the provided examples failing to convincingly represent the complex
dynamics of natural systems, such as forest biomass distribution. If we think to a forest
there are various heights of trees, and in general the biomass in not uniformly
distributed, and thus also the growth is not necessary constrained by the surface. The
sublinear scaling of the “production function”, f, if this is really the right conclusion
based on the references of the manuscript, must be the result of a cooperative
behavior of the interacting system and as such it should not appear as hand-added
like the authors do. Furthermore, in reference 27 the sublinear scaling with k=3/4
refers to the scaling of the single individual growth rather than to a community.

Feasibility Condition Neglected:

• The authors do not seem to consider the condition for the feasibility of the fixed points
(x* >= 0), which is critical. This oversight, especially evident in Equations 11 and 12,
i.e., Eq. 12 or its Gaussian approximation are normalized from 0 or from -infty to infty?
I think this is a very relevant issue calling into question the appropriateness of the
results.

Lack of Proper Scaling:

• There is no proper scaling of the interactions, so the thermodynamic limit is not well
defined. And this is not discussed or compared with other models in the literature
applying similar disputable choice (see E Mallmin, A Traulsen, S De Monte - arXiv
preprint arXiv:2306.11031, 2023). Relatedly, the comparison with GLV with quenched
disorder (e.g. “The properties of large random dynamical systems is often portrayed
in the ( sigma sqrt(N) , mu N ) plane [25] is not appropriate as such model scales the
interactions strengths with the system size.

Gaussian Approximation:

• The justification for employing a Gaussian approximation is unclear, given that
Equation 12 should be solved self-consistently. Ecologically, Gaussian species

abundance distributions (SADs) are not meaningful due to the prevalence of heavy-
tailed SADs in natural ecosystems.

#### Minor Comments:

Homogenous Case and Stability:

• The manuscript concludes that stability requires stronger self-interactions than cross-
interactions when alpha equals beta. While this is true that self-interactions promote

stability also for the Lotka-Volterra model, any negative mean species interaction
(indicating mutualism) in the homogeneous case leads to instability, irrespective of
system size. Thus, comparing this to the GLV model seems a stretch.

Notation:

• Using S instead of N for species richness would align better with ecological
conventions.

Discussion Quality:

• Given the issues raised, the discussion section of the manuscript needs substantial
improvement to convincingly argue the paper's contributions to the field.
In light of these concerns, before the authors submit their manuscript elsewhere, I
recommend to undertake significant revisions to address the weaknesses in their modelling
framework, the rationale behind their approach, and the ecological implications of their
findings

---

# How to address

## Overall

- Try to pitch the paper from a slightly different point of view, more "honest" and aware of what we already did in the Science and putting more stress on what is new/clearer in this letter.

## Overall

- Try to pitch the paper from a slightly different point of view, more "honest" and aware of what we already did in the Science and putting more stress on what is new/clearer in this letter.

## Reviewer 1

### Major comments

- Run simulations with distributed exponents and add to the SM (to be created).

### Minor comments

- Add Kronecker delta to Eq. (7). 
- Address the concern of the reviewer in the SM by studying Eq. (11) through the definition of the Gaussian variable $y=x^{\alpha-\beta}$.

## Referee B

### Major comments

- Point to Science for ecological justifications and in general to answer the first point.
- Point to Science paper for feasibility adding some discussion on this in the main text maybe.
- Maybe adjust something in the text to be more clear that the derivation of the results was obtained with rescaling and then we look at the non rescaled value of $\mu$ and $\sigma$.
- Answer to the reviewer that in this kind of conceptual work we are not necessarily interested in the realistic form of the SAD, indeed usual GLV papers have the Gaussian SAD prediction. In any case the model can still give non gaussian distribution in the case in which we use random growth rates etc... To conclude, the gaussian approximation is used only to more clearly present the results about complexity-stability but it is not necessary.

### Minor comments
- Just engage with the reviewer discussing mutualism etc, but not change anything necessarily.
- We stick to $N$, we don't want to relate to ecological literature, but more to complex systems. Moreover May used $N$ in his paper.
- Just answer something about all the changes that we made.

---

# Response to reviewer

## Referee A

We thank the referee for the thoughtful review of our work and for raising important points, addressed below, which we think helped us improve the paper.

- *The claim is probably true, but unfortunately it does not describe a generic situation, because it is very hard to imagine that the exponents alpha, beta, gamma used in the model are identical for all populations. Perhaps the model would be more interesting if it included a spectrum of different exponents, described, for example, by a probabilistic law.*

We agree that indeed a spectrum of different exponents is probably more realistic, and thank the reviewer to pointing that out.

We can consider the case in which the exponents are not identical for every variable $x_i$ but instead we have them from Gaussian distributions: $\alpha_i\sim\mathcal N(\alpha,\sigma_e)$, $\beta_i\sim\mathcal N(\beta,\sigma_e)$ and $\gamma_i\sim\mathcal N(\gamma,\sigma_e)$, respectively with mean $\alpha$, $\beta$ and $\gamma$, and, for simplicity, all with the same standard deviation $\sigma_e$. 

Simulations show that all our results are robust as long as $\sigma_e$ is small enough that $\displaystyle{\min_i\beta_i>\max_i\alpha_i}$.

As an example, we show in the plot below the probability of stability vs. $\sigma_e$ for a system with $S=100$, $\mu=\mu_s=\sigma=0.01$, $\alpha=\gamma=1$ and $\beta=3/2$.
The probability of stability is obtained as the fraction of stable systems out of $100$ realizations for each value of $\sigma_e$.
![](../plots/stoch-exp.png)

We decided, however, to not include this analysis in the letter because we would like to keep the focus on the existence of the two complexity-stability regimes rather than exploring more detailed ecological scenarios. We stick to the case in which $f$, $g$ and $h$ are independent from the variable index, following references [18] and [19].

- *The way of writing the matrix elements in Equations (7) is somewhat confusing. For clarity, the Kronecker delta can be used on the right side of these equations.*

We thank the referee for this comment, we modified Equations (7) accoridngly.

- *The mean field equations depend on the expected values of <x_^\gamma> and <x_^{2\gamma}>. The self-consistency condition requires that the probability distribution (12) has exactly the same expected values. This should be discussed in detail.*

We agree with the referee that the discussion about the expected values and self-consistency conditions needed more clarifications. 

In some cases, for example $\alpha=1, \beta=3, \gamma=1$, both expectations converge to finite values and we can safely compute the self-consistency equations. However in potential case of interests, and in the example case $\alpha=1, \beta=3/2, \gamma=1$ characterized by a distribution with a power-law tail with exponent $-3/2$, the moments diverge. We now modified the discussion removing the gaussian approximation and considering the introduction of a cut-off. The idea behind this cut-off can be described by the example below.

Consider, as an example which allows for a complete analytical treatment, the case of a power law distribution 
$$
P(x)=\frac{x^{-\alpha}}{\mathcal{Z}} ,
$$
defined from 1 to $\infty$ and with 
$$
\mathcal{Z}=\int_1^{\infty}x^{-\alpha}.
$$

Consider the case $\alpha=3/2$. The distribution is normalized with $\mathcal{Z}=2$, but the mean diverges. However, we would like to be able to describe the behaviour of the sample mean 
$$
\bar{x}_N\equiv\frac{1}{N}\sum_{i=1}^Nx_i,
$$
where the $x_i$ are extracted from $P(x)$.
For this purpose, we can define the quantity
$$
\langle x\rangle_{\Lambda}\equiv\int_1^{\Lambda}dxP(x)x,
$$
with the cut-off $\Lambda$ defined such that $\int_1^{\infty}dxP(x)=1/N$, i.e., such that there is statistically less than 1 variable with value above $\Lambda$ out of $N$ extracted variables. For the case $\alpha=3/2$ we have 
$$
\frac{1}{2}\int_{\Lambda}^{\infty}dxx^{-3/2}=\Lambda^{-1/2},
$$
and therefore $\Lambda=N^2$. We have for the mean
$$
\langle x\rangle_{\Lambda}=\frac{1}{2}\int_1^{N^2}dxx^{-1/2} = N-1.
$$
The result is plotted below, alongside sample mean for extractions of $N=10,$ $10^2,$ $10^3,$ $10^4,$ $10^5,$ $10^6$.

![](../plots/cut-off-justification.png)

## Referee B

We thank the referee for the thorough and critical review. We address each of the comments below point by point. We believe the results of our paper are now more transparent thanks to the work needed to address the weaknesses hihglighted by the referee. 

- *Modelling Framework Justification:*
    
     *The rationale behind the proposed generalization of the GLV model is claimed to be "natural" based on physical and biological grounds, specifically using power laws. Nevertheless, the literature extensively demonstrates species abundance growth being well-described by logistic equations or oscillatory predator-prey equations, that indeed are linear (except for the carrying capacity term). The justifications provided are weak, with the provided examples failing to convincingly represent the complex dynamics of natural systems, such as forest biomass distribution. If we think to a forest there are various heights of trees, and in general the biomass in not uniformly distributed, and thus also the growth is not necessary constrained by the surface. The sublinear scaling of the “production function”, f, if this is really the right conclusion based on the references of the manuscript, must be the result of a cooperative behavior of the interacting system and as such it should not appear as hand-added like the authors do. Furthermore, in reference 27 the sublinear scaling with k=3/4 refers to the scaling of the single individual growth rather than to a community.*

We understand the criticism of the referee, pointing out the need for better justification of models of this kind in ecology. Our goal in this letter, however, is not to propose a model for a specific ecological scenario. Rather, we employ this model for complex systems (following references [18] and [19]) to show in a minimal setting the existence of the two opposite complexity-stability relationships in disordered dynamical systems, possibly with applications beyond ecology.

Nevertheless, the examples we provide are indicative that models of this class can be relevant in ecology (see reference [17], where a discussion of possible mechanisms is present; even though admittedly more work is required in that direction, which is beyond the scope of our paper).

Finally, we are aware of the fact that reference [27] refers to the scaling of single individual, indeed we mention it to introduce the scaling at the higher level of organization:

"Biologically, the growth of organisms (populations of cells) has long been known to scale like $f (x) \sim x^k$ with $k\simeq 3/4$ [27], which can be understood in terms of hydrodynamic constraints on vascular and pulmonary networks. For reasons that are not currently understood, a similar pattern of growth appears to recur at the level of ecological communities [17, 28]".

- *Feasibility Condition Neglected:*

    *The authors do not seem to consider the condition for the feasibility of the fixed points (x\* >= 0), which is critical. This oversight, especially evident in Equations 11 and 12, i.e., Eq. 12 or its Gaussian approximation are normalized from 0 or from -infty to infty? I think this is a very relevant issue calling into question the appropriateness of the results.*

We thank the referee for highlighting this oversight.
We have now specified that the distribution in Eq.(11) is defined form zero to infinity and we point to reference [17] where a discussion on feasibility for systems described by this kind of distribution is present.

- *Lack of Proper Scaling:*
    
    *There is no proper scaling of the interactions, so the thermodynamic limit is not well defined. And this is not discussed or compared with other models in the literature applying similar disputable choice (see E Mallmin, A Traulsen, S De Monte - arXiv preprint arXiv:2306.11031, 2023). Relatedly, the comparison with GLV with quenched disorder (e.g. “The properties of large random dynamical systems is often portrayed in the ( sigma sqrt(N) , mu N ) plane [25] is not appropriate as such model scales the interactions strengths with the system size.*

The referee is absolutely correct in pointing out the lack of proper scaling in the derivation of the cavity results, we are grateful for pointing it out. We have now fixed that. However, we argue that, after a proper derivation of the analytical results, it is appropriate fix the the strength and heterogeneity of the interaction ($mean(A)=\mu$ and $var(A)=\sigma^2$) if our goal is to isolate and study the effects of changes in the number of degrees of freedom. We now discuss this, pointing out that it amount to be in a strong-interactions regime, and compare with reference (E Mallmin, A Traulsen, S De Monte *PNAS* 2024, now reference [34] in the manuscript) for an ecological example in which this choice is made to study chaotic turnover of species with broad abundance distributions.

- *Gaussian Approximation:*

    *The justification for employing a Gaussian approximation is unclear, given that Equation 12 should be solved self-consistently. Ecologically, Gaussian species abundance distributions (SADs) are not meaningful due to the prevalence of heavy-tailed SADs in natural ecosystems.*

We thank the referee for this important comment, we now removed the Gaussian approximation in the discussion and clarified how to treat the case in which self-consistently computing the moment in Equation (12) can be problematic, as explained above in the answers to referee A.

- *Homogenous Case and Stability:*
     *The manuscript concludes that stability requires stronger self-interactions than cross-interactions when alpha equals beta. While this is true that self-interactions promote stability also for the Lotka-Volterra model, any negative mean species interaction (indicating mutualism) in the homogeneous case leads to instability, irrespective of system size. Thus, comparing this to the GLV model seems a stretch.*

We are grateful to the referee for this comment, it helps to clarify the scope of our work. We have now specified everywhere in the manuscript, including Abstract, Introduction and Discussion, that we compare out results to the *competitive* Lotka-Volterra model and in general that our results are relevant for predominantly competitive systems.

- *Notation:*

     *Using S instead of N for species richness would align better with ecological conventions.*

We decided to keep $N$ to indicate the number of degrees of freedom because our goal is not to allign with ecological literature, rather we would like to speak to the community of scientists working in complex systems. We made this choice in the first place to align with Robert May notation in reference [1].

- *Discussion Quality:*

    *Given the issues raised, the discussion section of the manuscript needs substantial improvement to convincingly argue the paper's contributions to the field. In light of these concerns, before the authors submit their manuscript elsewhere, I recommend to undertake significant revisions to address the weaknesses in their modelling framework, the rationale behind their approach, and the ecological implications of their findings*

We are thankful for the critical reveiw overall. We extended the discussion and improved the paper in different aspects following suggestions of the referee.

---

# Letter to editor
