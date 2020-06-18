<!-- README.md is generated from README.Rmd. Please edit that file -->



# d3po #

<!-- badges: start -->
<!-- badges: end -->

The `r2d3` package provides a general framework with which R objects can be used to produce D3 documents. While the package provides very general capabilities, there are a handful of commonly used D3 visualizations that users must build by hand. The `d3po` package provides some of these common visualizations in an easier-to-use format, leveraging `r2d3` to produce the D3 documents.

## Installation ##

You can install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("tkmckenzie/d3po")
```
## Example ##

Several common D3 visualizations are included with `d3po`. Examples are shown below.

### Chord diagrams ###

Chord diagrams are often used to show relationships within a set, with strength of relationships represented by size of the chord. The `d3po::chord` function allows relationships to be specified either in an edgelist or as an adjacency matrix. Symmetric adjacency matrices with diagonal of zeros (or equivalent edgelists) are advised as they are more interpretable, but those characteristics are not required.


```r
labels = letters[1:3]

adjacency.matrix = matrix(c(0, 1, 2,
                            1, 0, 3,
                            2, 3, 0),
                          nrow = 3, byrow = TRUE)

chord(adjacency.matrix = adjacency.matrix, labels = labels)
#> Error in chord(adjacency.matrix = adjacency.matrix, labels = labels): could not find function "chord"
```

### Choropleths ###

The `d3po` package includes the ability to make choropleth maps at the U.S. county or state level. The vector `c("District of Columbia", datasets::state.name)` can be used to construct state-level data, and `d3po::us.counties` can be used to construct county-level data.


```r
require(dplyr)
#> Loading required package: dplyr
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

df.state = data.frame(state = c("District of Columbia", state.name),
                      value.state = rnorm(51, sd = 3))
df.county = us.counties %>%
  mutate(value.county = rnorm(n(), sd = 1)) %>%
  left_join(df.state, by = "state") %>%
  mutate(value = value.state + value.county)
#> Error in eval(lhs, parent, parent): object 'us.counties' not found

choropleth.state(df.state, value.column = "value.state")
#> Error in choropleth.state(df.state, value.column = "value.state"): could not find function "choropleth.state"
choropleth.county(df.county)
#> Error in choropleth.county(df.county): could not find function "choropleth.county"
```

### Word Clouds ###
Word clouds can be created with `d3po::cloud` by supplying a list of words and relative sizes. Words can also be individually colored or colored by group.


```r
require(dplyr)
require(rcorpora)
#> Loading required package: rcorpora

words = corpora("words/oprah_quotes")$oprahQuotes
words = tolower(unlist(strsplit(words, " ")))
words = gsub("[.,-;]+", "", words)
words = gsub("’", "'", words)
words = words[nchar(words) > 0]

stopwords = corpora("words/stopwords/en")$stopWords

word.df = data.frame(text = words)
word.df = word.df %>%
  filter(!(text %in% stopwords)) %>%
  group_by(text) %>%
  summarize(value = n(), .groups = "drop") %>%
  arrange(desc(value)) %>%
  slice(1:25) %>%
  mutate(value = 3 * value) # To make words a little larger in final image

cloud(word.df, text.color = "word", color.scheme = "RdYlGn")
#> Error in cloud(word.df, text.color = "word", color.scheme = "RdYlGn"): could not find function "cloud"
```

### Marimekko Charts ###
Marimekko charts are used to show both proportions amongst groups and total numbers relative to the overall population. These charts are especially useful for comparing similar variables across groups to show how those variables change proportional to both group size and the total population.


```r
num.groups = 5
num.vars = 3
df = data.frame(group = rep(LETTERS[1:num.groups], each = num.vars),
                var = rep(letters[1:num.vars], times = num.groups),
                value = runif(num.groups * num.vars, 0, 10))
marimekko(df, x.column = "group", y.column = "var", color.scheme = "Plasma")
#> Error in marimekko(df, x.column = "group", y.column = "var", color.scheme = "Plasma"): could not find function "marimekko"
```

### Sankey Diagrams ###
Sankey diagrams are useful for showing relationships between sets, with strength of relationships represented by size of the link. The function `d3po::sankey` creates a Sankey diagram from an edgelist.

```r
num.targets = 5
num.sources = 3
df = data.frame(source = rep(LETTERS[1:num.sources], each = num.targets),
                target = rep(letters[1:num.targets], times = num.sources),
                value = runif(num.groups * num.vars, 0, 10))
sankey(df)
#> Error in sankey(df): could not find function "sankey"
```
