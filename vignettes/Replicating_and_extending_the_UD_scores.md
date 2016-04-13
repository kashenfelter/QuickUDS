# Replicating and Extending the UD scores of Pemstein, Meserve, and Melton
Xavier Marquez  
`r Sys.Date()`  

This package contains data and convenience functions that can be used to replicate and extend the [Unified Democracy Scores](http://www.unified-democracy-scores.org/) of Pemstein, Meserve, and Melton (2010). It depends on the package ```mirt``` (Chalmers 2012), which can quickly compute full-information factor analyses.

The basic procedure for replicating or extending the UD scores is as follows. First, load the library and prepare the democracy data using the convenience functions ```prepare_data``` or ```prepare_democracy```; fit a simple ```mirt``` model; and finally, extract the scores. 



## Preparing your democracy indexes

Though you can use your own custom democracy indexes to generate latent (unified) democracy scores, the package provides a dataset, ```democracy```, which contains a large number of democracy measures (from more than 25 different datasets, of varying reliability and coverage) that you can use to generate custom unified democracy scores. (Use ```?democracy``` to view which measures are included in the dataset as well as links to their sources; they are also listed in the references below). For example, suppose we wanted to replicate exactly the [2011 release of the UD scores](http://www.unified-democracy-scores.org/archive.html). PMM's replication data for that release is included in the ```democracy``` dataset: we just need to select the variable names ending in ```_pmm``` and use the function ```prepare_democracy```


```r
library(QuickUDS)
library(mirt)

indexes <- names(democracy)[grep("pmm",names(democracy))]
indexes # The measures of democracy used to generate the 2011 release of the UDS
```

```
##  [1] "arat_pmm"         "blm_pmm"          "bollen_pmm"      
##  [4] "freedomhouse_pmm" "hadenius_pmm"     "mainwaring_pmm"  
##  [7] "munck_pmm"        "pacl_pmm"         "polity_pmm"      
## [10] "polyarchy_pmm"    "prc_pmm"          "vanhanen_pmm"
```

```r
data <- prepare_democracy(indexes)
```

The function ```prepare_democracy``` selects the appropriate colums from the ```democracy``` dataset, gets rid of "empty rows" (country-years that have no measurements of democracy for the chosen indexes; such patterns will make ```mirt``` fail), and runs ```prepare_data``` on the remaining indexes. 

```prepare_data``` transforms selected democracy indexes into ordinal variables suitable for use with ```mirt```, mostly following the advice in Pemstein, Meserve, and Melton's original article (2010). In particular, ```prepare_data``` will try to do the following on any dataset (whether the included ```democracy``` dataset or your own dataset of democracy scores): 

* If a selected index contains the string ```arat```, the function assumes the index is Arat (1991)'s 0-109 democracy score, and cuts it into 7 intervals with the following cutoffs: 50, 60, 70, 80, 90, and 100. The resulting score is ordinal from 1 to 8 (following Pemstein, Meserve, and Melton's advice).

* If a selected index contains the string ```bollen```, the function assumes the index is Bollen's (2001)'s 0-100 democracy score, and cuts it into 10 intervals with the following cutoffs: 10,20,30,40,50,60,70,80, and 90. The resulting score is ordinal from 1 to 10 (following Pemstein, Meserve, and Melton's advice).

* If a selected index contains the string ```eiu```, the function assumes the index is the Economist Intelligence Unit's 0-1 index of democracy, and it will round its value to the first decimal place and cut the result into 10 categories. The resulting score is ordinal from 1 to 11.

* If a selected index contains the string ```hadenius```, the function assumes the index is Hadenius (1992)'s 0-10 democracy score, and it will cut it into 8 intervals with the following cutoffs: 1, 2,3,4, 7, 8, and 9. The resulting score is ordinal from 1 to 8 (following Pemstein, Meserve, and Melton's advice). 

* If the selected index contains the string ```munck```, the function assumes the index is Munck's (2009)'s 0-1 democracy score, and it will cut it into 4 intervals with the following cutoffs: 0.5,0.5,0.75, and 0.99. The resulting score is ordinal from 1 to 4 (following Pemstein, Meserve, and Melton's advice).

* If the selected index contains the string ```peps```, the function assumes the index is one of the variants of the Participation-Enhanced Polity Score (Moon et al 2006), and it will round its value (eliminating the decimal) and then transform it into an ordinal measure from 1 to 21.

* If the selected index contains the string ```polity```, the function assumes this is the Polity IV score, and it set any values below -10 to NA and then transform them into an ordinal measure from 1 to 21.

* If the selected index contains the string ```v2x```, the function assumes this is one of the v2x_ continuous indexes of democracy from the V-Dem dataset (Coppedge et al 2015), and it will cut them into 20 categories. The resulting score is ordinal from 1 to 20.

* If the selected index contains the string ```vanhanen_democratization``` or ```vanhanen_pmm```, the function assumes this is Vanhanen's (2012)'s index of democratization, and it will cut it into 8 intervals with the following cutoffs: 5,10,15,20,25,30, and 35 (following Pemstein, Meserve, and Melton's advice). The resulting score is ordinal from 1 to 8.

```prepare_data``` will also work on column names that contain the following strings: 

* ```blm``` (assumes it's from Bowman, Lehoucq, and Mahoney 2005)
* ```bmr``` (assumes it's from Boix, Miller, and Rosato 2012)
* ```doorenspleet``` (assumes it's from Doorenspleet 2000)
* ```e_v2x``` (assumes it's one of the "ordinal" indexes from the V-dem project, Coppedge at al 2015)
* ```freedomhouse``` (assumes it's from Freedom House - must be reversed so that "more freedom" is higher)
* ```gwf``` (assumes it's from Geddes, Wright, and Frantz 2014 - the dichotomous democracy indicator only)
* ```kailitz``` (assumes it's from from Kailitz 2013 - democracy/electoral autocracy/non-democracy indicator only)
* ```lied``` (assumes it's from Skaaning, Gerring, and Bartusevičius 2015)
* ```mainwaring``` (assumes it's from Mainwaring and Perez Linan 2008)
* ```magaloni``` (assumes it's from Magaloni, Min and Chu 2013)
* ```pacl``` (assumes it's from Cheibub, Gandhi, and Vreeland 2010)
* ```pitf``` (assumes it's the measure of democracy used in Goldstone et. al 2010 or Taylor and Ulfelder 2015)
* ```poliarchy``` (assumes it's from Coppedge and Reinicke 1991)
* ```prc``` (assumes it's from Gasiorowski 1996 or Reich 2002)
* ```przeworski``` (assumes it's the "regime" variable from Przeworski 2010)
* ```svolik``` (assumes it's the democracy/dictatorship indicator from Svolik 2012)
* ```ulfelder``` (assumes it's from Ulfelder 2012)
* ```utip``` (assumes it's from Hsu 2008)
* ```wahman_teorell_hadenius``` (assumes it's a democracy/non-democracy indicator from Wahman, Teorell, and Hadenius 2013). 

In each of these cases the function ```prepare_data``` transforms the values of these scores by running ```as.numeric(unclass(factor(x)))```, which transforms each index into ordinal variables from 1 to the number of categories.

If you are using democracy indexes not included in the ```democracy``` dataset, or want to use your own custom measures of democracy, or transform them in a very particular way, you simply need to ensure that there are no "blank" country-years in your data (i.e., country-years without any democracy measurements) and that the indexes you are using are ordinal measures from 1 to N with every category present in the data. ```mirt``` is pretty flexible and forgiving: it will accept ordinal variables in any range and will attempt to transform your indexes so that every category is within a distance of 1 of its neighboring categories. But it's useful to have a good sense of what the algorithm is doing to your data before you begin!

## Fitting a democracy model

You then fit the model as follows:


```r
replication_2011_model <- mirt(data[ ,  indexes], model = 1, 
                               itemtype = "graded", SE = TRUE, verbose = FALSE)
```

This just tells ```mirt``` to fit a one-factor, full information graded response model like that in Pemstein, Meserve, and Melton 2010, and to calculate the standard errors for the coefficients. (See ```?mirt``` for details of the many options you can use to tweak your model). 

Fitting this model is reasonably fast, even in a three year old, not particularly fast computer:


```r
replication_2011_model@time
```

```
##    TOTAL     DATA ESTIMATE    Estep    Mstep       SE     POST 
##    10.85     0.33     8.71     1.15     7.54     1.79     0.00
```

There is a convenient wrapper for ```mirt(data[ , indexes ] ,model = 1, itemtype = "graded", SE = TRUE)```, in case you just want to re-fit Pemstein, Meserve, and Melton's original model without any special tweaking:


```r
replication_2011_model <- democracy_model(data, indexes, verbose = FALSE)
```

We can easily check that this model converges and that accounts for most of the variance in the democracy indexes:


```r
replication_2011_model
```

```
## 
## Call:
## mirt::mirt(data = data[, columns], model = model, itemtype = itemtype, 
##     SE = SE, verbose = FALSE)
## 
## Full-information item factor analysis with 1 factor(s).
## Converged within 1e-04 tolerance after 144 EM iterations.
## mirt version: 1.16 
## M-step optimizer: BFGS 
## EM acceleration: Ramsay
## Number of rectangular quadrature: 61
## 
## Information matrix estimated with method: crossprod
## Condition number of information matrix = 152303.6
## Second-order test: model is a possible local maximum
## 
## Log-likelihood = -55697.77
## AIC = 111583.5; AICc = 111585.5
## BIC = 112252.8; SABIC = 111954.1
```

```r
summary(replication_2011_model)
```

```
##                     F1    h2
## arat_pmm         0.901 0.812
## blm_pmm          0.993 0.985
## bollen_pmm       0.951 0.904
## freedomhouse_pmm 0.941 0.885
## hadenius_pmm     0.987 0.974
## mainwaring_pmm   0.995 0.989
## munck_pmm        0.955 0.912
## pacl_pmm         0.967 0.936
## polity_pmm       0.954 0.911
## polyarchy_pmm    0.965 0.932
## prc_pmm          0.969 0.938
## vanhanen_pmm     0.928 0.861
## 
## SS loadings:  11.038 
## Proportion Var:  0.92 
## 
## Factor correlations: 
## 
##    F1
## F1  1
```

And we can then extract the latent democracy scores, either via the ```mirt``` package's ```fscore``` function, or via this package's convenient wrapper ```democracy_scores``` (which returns a tidy dataset with the latent scores and automatically calculates 95\% confidence intervals):


```r
replication_2011_scores <-  fscores(replication_2011_model, full.scores = TRUE, full.scores.SE = TRUE)
# Not a data frame:
str(replication_2011_scores)
```

```
##  num [1:9137, 1:2] -1.89 -1.89 -1.57 -1.57 -1.45 ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : NULL
##   ..$ : chr [1:2] "F1" "SE_F1"
```

```r
replication_2011_scores <- democracy_scores(replication_2011_model)

# A data frame with confidence intervals:
head(replication_2011_scores)
```

```
##          z1     se.z1     pct975    pct025
## 1 -1.885971 0.4863005 -0.9328221 -2.839120
## 2 -1.885971 0.4863005 -0.9328221 -2.839120
## 3 -1.573987 0.3233880 -0.9401463 -2.207827
## 4 -1.573987 0.3233880 -0.9401463 -2.207827
## 5 -1.447844 0.2294384 -0.9981444 -1.897543
## 6 -1.573987 0.3233880 -0.9401463 -2.207827
```

```r
# We then bind these scores to the transformed data to associate them with the right country-years
replication_2011_scores <- cbind(data,replication_2011_scores)
```

We can also check that these scores are, in fact, perfectly correlated with Pemstein, Meserve, and Melton's 2011 UDS release:


```r
library(dplyr)
comparison <- left_join(replication_2011_scores, uds_2011, by=c("country_name","year","GWn"))

Hmisc::rcorr(comparison %>% select(z1,mean) %>% as.matrix())
```

```
##      z1 mean
## z1    1    1
## mean  1    1
## 
## n= 9137 
## 
## 
## P
##      z1 mean
## z1       0  
## mean  0
```

(For more details on the relationship between the original UD scores and the replicated scores produced using this method, see my working paper [Marquez 2016](http://ssrn.com/abstract=2753830)).

## Extending the model

Now suppose you want to create a new Unified Democracy score derived from Pemstein, Meserve, and Melton's original source measures but that also maximizes the democracy information available in other datasets, including:

* The dichotomous indicator of democracy in the Boix, Miller and Rosato dataset of political regimes (Boix Miller and Rosato 2012)
* The full extent of the Political Regime Change dataset (Gasiorowski 1996 and Reich 2002), Vanhanen's index of democratization (Vanhanen 2012), Bowman, Lehoucq, and Mahoney's data on Central America (Bowman, Lehoucq, and Mahoney 2005) and Mainwaring, Brinks and Perez-Linan's data on Latin America (Mainwaring, Brinks, and Perez-Linan 2008), all of which go back to the beginning of the 20th century or before but are not used to the fullest extent in the official UD releases.
* One of the new V-Dem indexes of democracy, ordinal or continuous (Coppedge et al 2015)
* Renske Doorenspleet's dichotomous indicator of democracy including suffrage info (Doorenspleet 2000)
* The Economist Intelligence Unit's index of democracy
* The most current release of Freedom House's data, to 2015
* The indicators of democracy in various autocratic regime datasets (Geddes, Wright, and Frantz 2014; Svolik 2012; Kalitz 2013; Wahman, Teorell and Hadenius 2013)
* The 7-level Lexical Index of Democracy and Autocracy (Skaaning, Gerring, and Bartusevičius. 2015)
* Jay Ulfelder's dichotomous indicator of democracy (Ulfelder 2012)

This package makes the process extremely simple:


```r
indexes <- c("arat_pmm","blm","bmr_democracy","bollen_pmm","doorenspleet","eiu","freedomhouse",
             "gwf","hadenius_pmm","kailitz_tri","lied","mainwaring","munck_pmm","pacl",
             "polity2","polyarchy_pmm","prc","svolik","ulfelder",
             "v2x_polyarchy","vanhanen_democratization","wahman_teorell_hadenius")
data <- prepare_democracy(indexes)
extended_model <- democracy_model(data,indexes, verbose=FALSE)
extended_scores <- democracy_scores(extended_model)
extended_scores <- bind_cols(data,extended_scores)
extended_model
```

```
## 
## Call:
## mirt::mirt(data = data[, columns], model = model, itemtype = itemtype, 
##     SE = SE, verbose = FALSE)
## 
## Full-information item factor analysis with 1 factor(s).
## Converged within 1e-04 tolerance after 217 EM iterations.
## mirt version: 1.16 
## M-step optimizer: BFGS 
## EM acceleration: Ramsay
## Number of rectangular quadrature: 61
## 
## Information matrix estimated with method: crossprod
## Condition number of information matrix = 115934.9
## Second-order test: model is a possible local maximum
## 
## Log-likelihood = -161653.5
## AIC = 323601; AICc = 323602.8
## BIC = 324789.5; SABIC = 324322.3
```

```r
extended_model@time
```

```
##    TOTAL     DATA ESTIMATE    Estep    Mstep       SE     POST 
##    32.22     0.97    24.13     5.67    18.45     7.10     0.00
```

```r
extended_scores %>% select(country_name,GWn,cown,year,z1,se.z1,pct025,pct975)
```

```
## Source: local data frame [23,974 x 8]
## 
##    country_name   GWn  cown  year         z1     se.z1    pct025    pct975
##           (chr) (dbl) (dbl) (dbl)      (dbl)     (dbl)     (dbl)     (dbl)
## 1   Afghanistan   700   700  1747 -0.6162223 0.6785283 -1.946138 0.7136931
## 2   Afghanistan   700   700  1748 -0.6162223 0.6785283 -1.946138 0.7136931
## 3   Afghanistan   700   700  1749 -0.6162223 0.6785283 -1.946138 0.7136931
## 4   Afghanistan   700   700  1750 -0.6162223 0.6785283 -1.946138 0.7136931
## 5   Afghanistan   700   700  1751 -0.6162223 0.6785283 -1.946138 0.7136931
## 6   Afghanistan   700   700  1752 -0.6162223 0.6785283 -1.946138 0.7136931
## 7   Afghanistan   700   700  1753 -0.6162223 0.6785283 -1.946138 0.7136931
## 8   Afghanistan   700   700  1754 -0.6162223 0.6785283 -1.946138 0.7136931
## 9   Afghanistan   700   700  1755 -0.6162223 0.6785283 -1.946138 0.7136931
## 10  Afghanistan   700   700  1756 -0.6162223 0.6785283 -1.946138 0.7136931
## ..          ...   ...   ...   ...        ...       ...       ...       ...
```

```mirt``` will stop by default after 500 EM cycles, but some models will take longer to converge. If your model has not converged after 500 iterations of the algorithm, you can try increasing the number of cycles with the ```technical``` option:


```r
extended_model <- democracy_model(data,indexes, verbose=FALSE, technical = list(NCYCLES = 2500)) 
```

Use ```?mirt``` for more details.

One important point to note about latent variable democracy scores is that they are normalized with mean zero and standard deviation one, so a score of 1 just means that the country-year is 1 standard deviation more democratic than the average country-year in the sample. But this means that adding extra country-years to our model will typically result in scores that have a higher mean (though usually smaller standard errors) than the original UD model, given that the world has become substantially more democratic over the last two centuries:


```r
countries <- c("United States of America","United Kingdom","Argentina","Chile","Venezuela","Spain")

data <- bind_rows(extended_scores %>% mutate(version = "Extension"),
                  uds_2014 %>% rename(z1 = mean) %>% mutate(version = "PMM2014 release"))

data <- data %>% arrange(version,country_name,year) %>% filter(country_name %in% countries)

library(ggplot2)

ggplot(data = data, aes(x=year,y=z1,ymin = pct025,ymax = pct975, color = version, fill= version)) + 
  geom_path() + 
  geom_ribbon(alpha=0.2) + 
  theme_bw() + 
  labs(x = "Year", y = "Latent unified democracy scores,\nper year")  + 
  theme(legend.position="bottom") + 
  guides(color = guide_legend(ncol=1),fill = guide_legend(nrow=1)) + 
  facet_wrap(~country_name,ncol=2)  
```

![](Replicating_and_extending_the_UD_scores_files/figure-html/unnamed-chunk-11-1.png)

If necessary, one can therefore "match" the extended scores to the official UD release by substracting the mean of the extended scores for the period of the UD release one wants to match from the extended scores:


```r
mean_ud_period <- mean(extended_scores$z1[ paste(extended_scores$country_name,extended_scores$year) 
                                           %in% paste(uds_2014$country_name,uds_2014$year) ])

# This is how much higher the extended scores are than the scores in UDS 2014 release,
# on average
mean_ud_period
```

```
## [1] 0.483148
```

```r
extended_scores <- extended_scores %>% 
  mutate(adj.z1 = z1 - mean_ud_period, 
         adj.pct025 = pct025 - mean_ud_period, 
         adj.pct975 = pct975 - mean_ud_period)

data <- bind_rows(extended_scores %>% 
                    mutate(version = "Extension, adjusted mean"),
                  uds_2014 %>% 
                    rename(adj.z1 = mean, adj.pct975 = pct975, adj.pct025 = pct025) %>% 
                    mutate(version = "PMM2014 release"))

data <- data %>% arrange(version,country_name,year) %>% filter(country_name %in% countries)

library(ggplot2)

ggplot(data = data, aes(x=year,y=adj.z1,ymin = adj.pct025,ymax = adj.pct975, color = version, fill= version)) + 
  geom_path() + 
  geom_ribbon(alpha=0.2) + 
  theme_bw() + 
  labs(x = "Year", y = "Latent unified democracy scores,\nper year")  + 
  theme(legend.position="bottom") + 
  guides(color = guide_legend(ncol=1),fill = guide_legend(nrow=1)) + 
  facet_wrap(~country_name,ncol=2)  
```

![](Replicating_and_extending_the_UD_scores_files/figure-html/unnamed-chunk-12-1.png)

In the graph above, we can see that the 2014 release of the UDS seems to overestimate the degree of democracy in the USA in the early decades of 1950 relative to the "extended" scores. The package offers a convenience function to perform this adjustment:


```r
extended_scores <- match_to_uds(extended_scores, release = 2014)
```

These scores have a more natural interpretation when transformed to a 0-1 scale using the cumulative distribution function as the "probability that a country-year is democratic" (so the 0 is now a natural minimum, and 1 a natural maximum). We can put them in this form as follows


```r
extended_scores <- extended_scores %>% mutate(index = pnorm(adj.z1), index.pct025 = pnorm(adj.pct025), index.pct975 = pnorm(adj.pct975))
```

It is also possible to to set the cutpoint for this index at, for example, the average cutpoint in the latent variable of the dichotomous indexes of democracy (so that 0.5 correponds more naturally to the point at which a regime could be either democratic or non-democratic according to the dichotomous measures of democracy included in your model):


```r
cutpoints_extended <- cutpoints(extended_model)

cutpoints_extended <- cutpoints_extended %>% filter(type != "a1")

cutpoints_extended <- left_join(cutpoints_extended,democracy_long %>% select(variable,index_type)  %>% distinct())
```

```
## Joining by: "variable"
```

```r
dichotomous_cutpoints <- cutpoints_extended %>% filter(index_type == "Dichotomous")

dichotomous_cutpoints <- mean(dichotomous_cutpoints$estimate)

extended_scores <- extended_scores %>% mutate(adj.z1 = z1 - dichotomous_cutpoints, 
                                        adj.pct025 = pct025 - dichotomous_cutpoints, 
                                        adj.pct975 = pct975 - dichotomous_cutpoints,
                                        index = pnorm(adj.z1),
                                        index.pct025 = pnorm(adj.pct025),
                                        index.pct975 = pnorm(adj.pct975))

ggplot(data = extended_scores %>% filter(country_name %in% countries), 
       aes(x=year,y=index,ymin = index.pct025,ymax = index.pct975)) + 
  geom_path() + 
  geom_ribbon(alpha=0.2) + 
  theme_bw() + 
  labs(x = "Year", y = "Latent unified democracy scores,\nper year\nconverted to 0-1 probability scale")  + 
  theme(legend.position="bottom") + 
  guides(color = guide_legend(ncol=1),fill = guide_legend(nrow=1)) + 
  geom_hline(yintercept=0.5,color="red") +
  facet_wrap(~country_name,ncol=2)  
```

![](Replicating_and_extending_the_UD_scores_files/figure-html/unnamed-chunk-15-1.png)

A pre-computed version of the extended UDS scores, with data from all the indexes mentioned above, plus the participation-enhanced Polity Scores of Moon et al (2006), a trichotomous democracy indicator calculated from Magaloni, Min, and Chu's "Autocracies of the World" datset (Magaloni, Min and Chu 2013), a dichotomous democracy indicator calculated from Hsu (2008), and an indicator of democracy used by the Political Instability Task Force (Goldstein et. al 2010; Taylor and Ulfelder 2015), is included with the package; it can be loaded by simply typing ```extended_uds```. Use ```?extended_uds``` to examine the documentation for all its variables; see my working paper ([Marquez 2016](http://ssrn.com/abstract=2753830)) for more detail on the data and its uses.

## Extracting useful information from the model

The ```mirt``` package offers a great number of powerful tools to examine and diagnose the fitted model, including functions to extract model cutpoints and item information curves. But this package also contains two convenience functions that wrap ```mirt``` tools to quickly extract democracy rater discrimination parameters, rater cutoffs, and rater information curves from a model produced by ```democracy_model``` in a tidy data frame format suitable for graphing:


```r
replication_2011_cutpoints <- cutpoints(replication_2011_model)
replication_2011_cutpoints
```

```
## Source: local data frame [94 x 8]
## Groups: variable [12]
## 
##       par CI_2.5 CI_97.5 variable  type     estimate       pct975
##     (dbl)  (dbl)   (dbl)    (chr) (chr)        (dbl)        (dbl)
## 1   3.536  3.310   3.763 arat_pmm    a1 -1.000000000 -1.000000000
## 2   5.072  4.839   5.305 arat_pmm    d1 -1.434389140 -1.461933535
## 3   3.599  3.394   3.805 arat_pmm    d2 -1.017816742 -1.025377644
## 4   1.512  1.347   1.677 arat_pmm    d3 -0.427601810 -0.406948640
## 5   0.152 -0.014   0.317 arat_pmm    d4 -0.042986425  0.004229607
## 6  -1.485 -1.664  -1.305 arat_pmm    d5  0.419966063  0.502719033
## 7  -5.022 -5.309  -4.734 arat_pmm    d6  1.420248869  1.603927492
## 8  13.833  7.440  20.226  blm_pmm    a1 -1.000000000 -1.000000000
## 9   0.057 -0.735   0.849  blm_pmm    d1 -0.004120581  0.098790323
## 10 -6.525 -9.578  -3.471  blm_pmm    d2  0.471698113  1.287365591
## ..    ...    ...     ...      ...   ...          ...          ...
## Variables not shown: pct025 (dbl)
```

```r
# We don't want to plot the discrimination parameter here, only the cutpoints
replication_2011_cutoffs <- replication_2011_cutpoints %>% filter(type != "a1") 

# We plot the "normalized" cutpoints ("estimate," in the same scale as the latent scores), 
# not the untransformed ones ("par")

ggplot(data = replication_2011_cutoffs, aes(x=variable,y = estimate, ymin = pct025,ymax=pct975))  + 
  theme_bw() + 
  labs(x="",y="Unified democracy level rater cutoffs") + 
  geom_point() + 
  geom_errorbar() + 
  geom_hline(yintercept =0, color="red") + 
  coord_flip()
```

![](Replicating_and_extending_the_UD_scores_files/figure-html/unnamed-chunk-16-1.png)

```r
# We can also plot discrimination parameters, which are in a different scale:
replication_2011_discrimination <- replication_2011_cutpoints %>% filter(type == "a1")

ggplot(data = replication_2011_discrimination, 
       aes(x=reorder(variable,par),y = par, ymin = CI_2.5,ymax=CI_97.5))  + 
  theme_bw() + 
  labs(x="",y="Discrimination parameter for each rater
       \n(higher value means fewer idiosyncratic errors relative to latent score)") + 
  geom_point() + 
  geom_errorbar() + 
  coord_flip()
```

![](Replicating_and_extending_the_UD_scores_files/figure-html/unnamed-chunk-16-2.png)

```r
# And we can plot item information curves for each rater:
replication_2011_info <- raterinfo(replication_2011_model)
```

```
## Warning in rbind_all(x, .id): Unequal factor levels: coercing to character
```

```r
replication_2011_info
```

```
## Source: local data frame [732 x 3]
## 
##       rater theta         info
##       (chr) (dbl)        (dbl)
## 1  arat_pmm  -6.0 1.216458e-06
## 2  arat_pmm  -5.8 2.467471e-06
## 3  arat_pmm  -5.6 5.005032e-06
## 4  arat_pmm  -5.4 1.015223e-05
## 5  arat_pmm  -5.2 2.059281e-05
## 6  arat_pmm  -5.0 4.177044e-05
## 7  arat_pmm  -4.8 8.472684e-05
## 8  arat_pmm  -4.6 1.718581e-04
## 9  arat_pmm  -4.4 3.485881e-04
## 10 arat_pmm  -4.2 7.070377e-04
## ..      ...   ...          ...
```

```r
ggplot(data = replication_2011_info, aes(x=theta,y=info)) + 
  geom_path() + 
  facet_wrap(~rater) + 
  theme_bw() + 
  labs(x="Latent democracy score",y = "Information") + 
  theme(legend.position="bottom")
```

![](Replicating_and_extending_the_UD_scores_files/figure-html/unnamed-chunk-16-3.png)

Finally, the package offers a simple function to estimate the probability that a given country is more democratic than another in a given year, accounting for the uncertainty in the UD-style measures. For example, suppose we want to know the probability that the USA was more democratic than France in the year 2000 for both the replicated 2011 scores and our extended model:


```r
prob_more(replication_2011_scores, "United States of America","France", 2000)
```

```
## [1] 0.8780068
```

```r
prob_more(extended_scores, "United States of America","France", 2000)
```

```
## [1] 0.7322454
```

Or perhaps we wish to know the probability that the United States was more democratic in the year 2000 than in the year 1953:


```r
prob_more(replication_2011_scores, "United States of America","United States of America", c(2000,1953))
```

```
## [1] 0.9179374
```

```r
prob_more(extended_scores, "United States of America","United States of America", c(2000,1953))
```

```
## [1] 0.9998778
```

If you find this package useful, cite both it and Pemstein, Meserve, and Melton's original paper (Pemstein Meserve and Melton 2010). Citation information can be automatically generated by using ```citation```:


```r
citation("QuickUDS")
```

```
## 
## To cite package 'QuickUDS' in publications use:
## 
##   Xavier Marquez (2016). QuickUDS: Extend the Unified Democracy
##   Scores Backwards and Forwards in Time easily. R package version
##   0.1.1. https://github.com/xmarquez/QuickUDS
## 
## A BibTeX entry for LaTeX users is
## 
##   @Manual{,
##     title = {QuickUDS: Extend the Unified Democracy Scores Backwards and Forwards in Time easily},
##     author = {Xavier Marquez},
##     year = {2016},
##     note = {R package version 0.1.1},
##     url = {https://github.com/xmarquez/QuickUDS},
##   }
## 
## ATTENTION: This citation information has been auto-generated from
## the package DESCRIPTION file and may need manual editing, see
## 'help("citation")'.
```

# References
Arat, Zehra F. 1991. Democracy and human rights in developing countries. Boulder: Lynne Rienner Publishers.

Boix, Carles, Michael Miller, and Sebastian Rosato. 2012. A Complete Data Set of Political Regimes, 1800–2007. Comparative Political Studies 46 (12): 1523-1554. DOI:10.1177/0010414012463905. Original data available at https://sites.google.com/site/mkmtwo/democracy-v2.0.dta?attredirects=0

Bollen, Kenneth A. 2001. "Cross-National Indicators of Liberal Democracy, 1950-1990." 2nd ICPSR version. Chapel Hill, NC: University of North Carolina, 1998. Ann Arbor, MI: Inter-university Consortium for Political and Social Research, 2001. Original data available at http://webapp.icpsr.umich.edu/cocoon/ICPSR-STUDY/02532.xml.

Bowman, Kirk, Fabrice Lehoucq, and James Mahoney. 2005. Measuring Political Democracy: Case Expertise, Data Adequacy, and Central America. Comparative Political Studies 38 (8): 939-970. http://cps.sagepub.com/content/38/8/939. Data available at http://www.blmdemocracy.gatech.edu/.

Chalmers, R. Philip.  2012.  "Mirt: A Multidimensional Item Response Theory Package for the R Environment."  2012 48(6): 1-29. http://www.jstatsoft.org/v48/i06/

Cheibub, Jose Antonio, Jennifer Gandhi, and James Raymond Vreeland. 2010. "Democracy and Dictatorship Revisited." Public Choice. 143(1):67-101. DOI:10.1007/s11127-009-9491-2 Original data available at https://sites.google.com/site/joseantoniocheibub/datasets/democracy-and-dictatorship-revisited.

Coppedge, Michael, John Gerring, Staffan I. Lindberg, Svend-Erik Skaaning, and Jan Teorell, with David Altman, Michael Bernhard, M. Steven Fish, Adam Glynn, Allen Hicken, Carl Henrik Knutsen, Kelly McMann, Pamela Paxton, Daniel Pemstein, Jeffrey Staton, Brigitte Zimmerman, Frida Andersson, Valeriya Mechkova, Farhad Miri. 2015. V-Dem Codebook v5. Varieties of Democracy (V-Dem) Project. Original data available at https://v-dem.net/en/data/.

Coppedge, Michael and Wolfgang H. Reinicke. 1991. Measuring Polyarchy. In On Measuring Democracy: Its Consequences and Concomitants, ed. Alex Inkeles. New Brunswuck, NJ: Transaction pp. 47-68.

Doorenspleet, Renske. 2000. Reassessing the Three Waves of Democratization. World Politics 52 (03): 384-406. DOI:10.1017/S0043887100016580.

Economist Intelligence Unit. 2012. Democracy Index 2012: Democracy at a Standstill.

Freedom House. 2015. "Freedom in the World." Original data
available at http://www.freedomhouse.org.

Gasiorowski, Mark J. 1996. "An Overview of the Political Regime Change
Dataset." Comparative Political Studies 29(4):469-483. DOI:10.1177/0010414096029004004

Geddes, Barbara, Joseph Wright, and Erica Frantz. 2014. Autocratic Breakdown and Regime Transitions: A New Data Set.
Perspectives on Politics 12 (1): 313-331. DOI:10.1017/S1537592714000851. Original data available at http://dictators.la.psu.edu/.

Goldstone, Jack, Robert Bates, David Epstein, Ted Gurr, Michael Lustik, Monty Marshall, Jay Ulfelder, and Mark Woodward. 2010. A Global Model for Forecasting Political Instability. American Journal of Political Science 54 (1): 190-208. DOI:10.1111/j.1540-5907.2009.00426.x

Hadenius, Axel. 1992. Democracy and Development. Cambridge: Cambridge University Press.

Hadenius, Axel & Jan Teorell. 2007. "Pathways from Authoritarianism", Journal of Democracy 18(1): 143-156.

Hsu, Sara "The Effect of Political Regimes on Inequality, 1963-2002," UTIP Working Paper No. 53 (2008), http://utip.gov.utexas.edu/papers/utip_53.pdf. Data available for download at http://utip.gov.utexas.edu/data/.

Kailitz, Steffen. 2013. Classifying political regimes revisited: legitimation and durability. Democratization 20 (1): 39-60. DOI:10.1080/13510347.2013.738861. Original data available at http://dx.doi.org/10.1080/13510347.2013.738861.

Mainwaring, Scott, Daniel Brinks, and Anibal Perez Linan. 2008. "Political Regimes in Latin America, 1900-2007." Original data available from http://kellogg.nd.edu/scottmainwaring/Political_Regimes.pdf.

Magaloni, Beatriz, Jonathan Chu, and Eric Min. 2013. Autocracies of the World, 1950-2012 (Version 1.0). Dataset, Stanford University. Original data and codebook available at http://cddrl.fsi.stanford.edu/research/autocracies_of_the_world_dataset/. 

Marshall, Monty G., Ted Robert Gurr, and Keith Jaggers. 2012. "Polity IV: Political Regime Characteristics and Transitions, 1800-2012." Updated to 2015. Original data available from http://www.systemicpeace.org/polity/polity4.htm.

Marquez, Xavier. 2016. "A Quick Method for Extending the Unified Democracy Scores" (March 23, 2016). Available at SSRN: http://ssrn.com/abstract=2753830

Moon, Bruce E., Jennifer Harvey Birdsall, Sylvia Ceisluk, Lauren M. Garlett, Joshua J. Hermias, Elizabeth Mendenhall, Patrick D. Schmid, and Wai Hong Wong (2006) "Voting Counts: Participation in the Measurement of Democracy" Studies in Comparative International Development 42, 2 (Summer, 2006). DOI:10.1007/BF02686309. The complete dataset is available here: http://www.lehigh.edu/~bm05/democracy/Obtain_data.htm.

Munck, Gerardo L. 2009. Measuring Democracy: A Bridge Between Scholarship and Politics. Baltimore: Johns Hopkins University Press.

Pemstein, Daniel, Stephen Meserve, and James Melton. 2010. Democratic Compromise: A Latent Variable Analysis of Ten Measures of Regime Type. Political Analysis 18 (4): 426-449. DOI:10.1093/pan/mpq020. The UD scores are available here: http://www.unified-democracy-scores.org/

Pemstein, Daniel, Stephen A. Meserve, and James Melton. 2013. "Replication data for: Democratic Compromise: A Latent Variable Analysis of Ten Measures of Regime Type." In: Harvard Dataverse. http://hdl.handle.net/1902.1/PMM

Reich, G. 2002. Categorizing Political Regimes: New Data for Old Problems. Democratization 9 (4): 1-24. DOI:10.1080/714000289. http://www.tandfonline.com/doi/pdf/10.1080/714000289.

Skaaning, Svend-Erik, John Gerring, and Henrikas Bartusevičius. 2015. A Lexical Index of Electoral Democracy. Comparative Political Studies 48 (12): 1491-1525. DOI:10.1177/0010414015581050. Original data available from http://thedata.harvard.edu/dvn/dv/skaaning.

Svolik, Milan. 2012. The Politics of Authoritarian Rule. Cambridge and New  York: Cambridge University Press. Original data available from http://campuspress.yale.edu/svolik/the-politics-of-authoritarian-rule/.

Taylor, Sean J. and Ulfelder, Jay, A Measurement Error Model of Dichotomous Democracy Status (May 20, 2015). Available at SSRN: http://ssrn.com/abstract=2726962

Ulfelder, Jay. 2012. "Democracy/Autocracy Data Set." In: Harvard Dataverse. http://hdl.handle.net/1902.1/18836.

Vanhanen, Tatu. 2012. "FSD1289 Measures of Democracy 1810-2012." Original data available from http://www.fsd.uta.fi/english/data/catalogue/FSD1289/meF1289e.html

Wahman, Michael, Jan Teorell, and Axel Hadenius. 2013. Authoritarian regime types revisited: updated data in comparative perspective. Contemporary Politics 19 (1): 19-34. DOI:10.1080/13569775.2013.773200