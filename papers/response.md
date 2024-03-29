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

- Should we remove "Beyond May" from the title?

## Reviewer 1

### Major comments

- Run simulations with distributed exponents and add to the SM (to be created).

### Minor comments

- Add Kronecker delta to Eq. (7).
- Address the concern of the reviewer in the SM by studying Eq. (11) through the definition of the Gaussian variable $y=x^{\alpha-\beta}$.

## Reviewer 2

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

## Reviewer 1

## Reviewer 2

We thank the Reveiwer...



---

# Letter to editor
