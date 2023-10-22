
<!-- README.md is generated from README.Rmd. Please edit that file -->

# hagstofa

<!-- badges: start -->
<!-- badges: end -->

## Sækja pakkann

Það er hægt að sækja pakkann frá [GitHub](https://github.com/) með
kóðanum:

``` r
# install.packages("devtools")
devtools::install_github("bgautijonsson/hagstofa")
```

## Sýnidæmi: Íslensk fyrirtæki

``` r
library(hagstofa)
```

Hagstofan heldur utan um ýmisleg gögn um íslensk fyrirtæki og afkomuna
þeirra. Hér skulum við skoða [rekstrar- og efnahagsyfirlit þeirra frá
2002 -
2021](https://px.hagstofa.is/pxis/pxweb/is/Atvinnuvegir/Atvinnuvegir__fyrirtaeki__afkoma__2_rekstrarogefnahags/FYR08010.px).
Með því að velja einhverja flokka, velja áfram og fara svo í flipann *Um
töflu* getum við fundið **Nota töfluna í eigin kerfum**. Smellum á það
og þá sjáum við *px API* slóð fyrir gögnin.

Við gætum líka leitað að töflunni með því að nota fallið
`hg_list_tables()`, sem býr til HTML töflu með öllum töflum
Hagstofunnar. Við getum leitað í þeirri töflu til að finna vefslóð
gagna. Það er líka hægt að fletta í töflunni á vefsíðu Metils:
<https://metill.is/hagstofutoflur/>

Það er vel hægt að nota til dæmis [pxweb
pakkann](http://ropengov.github.io/pxweb/) frá
[rOpenGov](https://ropengov.org/) til að sækja gögn í gegnum þetta API,
en mig hefur lengi langað að gera það aðeins þjálla að sækja gögn
Hagstofunnar.

Fallið `hg_data()` og meðfylgjandi `collect()` skipun eru fyrsta
tilraunin til þess. Ef við notum `hg_data()` á API slóðina fyrir gögnin
fáum við eftirfarandi:

Hafandi flett slóðinni upp á síðu Hagstofunnar, eða leitað að töflunni
eftir að hafa notað fallið hg_list_tables(), getum við svo sótt gögnin
þæginlega.

``` r
url <- "https://px.hagstofa.is:443/pxis/api/v1/is/Atvinnuvegir/fyrirtaeki/afkoma/2_rekstrarogefnahags/FYR08010.px"

d <- hg_data(url)

head(d)
#> # A tibble: 6 × 3
#>   Atvinnugrein                                    Reikningsliður Tekjuár
#>   <chr>                                           <chr>          <chr>  
#> 1 Aðrir farþegaflutningar á landi (ÍSAT nr. 4939) 0-1-0 Fjöldi   2002   
#> 2 Aðrir farþegaflutningar á landi (ÍSAT nr. 4939) 0-1-0 Fjöldi   2003   
#> 3 Aðrir farþegaflutningar á landi (ÍSAT nr. 4939) 0-1-0 Fjöldi   2004   
#> 4 Aðrir farþegaflutningar á landi (ÍSAT nr. 4939) 0-1-0 Fjöldi   2005   
#> 5 Aðrir farþegaflutningar á landi (ÍSAT nr. 4939) 0-1-0 Fjöldi   2006   
#> 6 Aðrir farþegaflutningar á landi (ÍSAT nr. 4939) 0-1-0 Fjöldi   2007
```

Þið sjáið kannski að við höfum ekki sótt nein gögn ennþá. Hins vegar
höfum við útbúið töflu sem inniheldur allar mælingar sem við gætum sótt
gögn fyrir. Ef við viljum t.d. bara sækja gögn um fjölda fyrirtækja í
fiskeldi fyrir allt tímabilið getum við keyrt

``` r
d |> 
  dplyr::filter(
    Reikningsliður == "0-1-0 Fjöldi",
    Atvinnugrein == "Fiskeldi (ÍSAT nr. 032)"
  ) |> 
  collect()
#> # A tibble: 20 × 4
#>    Atvinnugrein            Reikningsliður Tekjuár Rekstrar- og efnahagsyfirlit…¹
#>    <chr>                   <chr>          <chr>                            <dbl>
#>  1 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2002                                48
#>  2 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2003                                61
#>  3 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2004                                55
#>  4 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2005                                50
#>  5 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2006                                51
#>  6 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2007                                47
#>  7 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2008                                46
#>  8 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2009                                53
#>  9 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2010                                49
#> 10 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2011                                52
#> 11 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2012                                50
#> 12 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2013                                58
#> 13 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2014                                59
#> 14 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2015                                56
#> 15 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2016                                56
#> 16 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2017                                57
#> 17 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2018                                53
#> 18 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2019                                53
#> 19 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2020                                56
#> 20 Fiskeldi (ÍSAT nr. 032) 0-1-0 Fjöldi   2021                                55
#> # ℹ abbreviated name: ¹​`Rekstrar- og efnahagsyfirlit 2002-2021`
```
