#1st step: loadd tidyverse
library(tidyverse)


# Reading in data ---------------------------------------------------------


#read in data using read_csv function
#create an object and give it the name gapminder_data
##ask how to enable rainbow parentheses
gapminder_data <-read_csv("data/gapminder_data.csv")
#if you see the error "couldn't find function" you probably didn't load the library

#Summarize is a function that creates a heading of an outline. to create it code>insert section> type label
#Then you can view the outline in the top right corner
# Summarize ---------------------------------------------------------------

#What is the mean life expectancy

summarize(gapminder_data, mean(lifeExp))

#that gives you a table and dataframe of one number or cell
#the 'mean(lifeExp)' in the tibble output is the column name

#now we can change the name of the colummn to averageLifeExp

summarize(gapminder_data, averageLifeExp = mean(lifeExp))


## Piping ------------------------------------------------------------------

#create a pipe using crt+shift+M
#takes the data and sends it down a pipe
#e.g. when I type 'summarize' it will automatically assume that we are taking the data and 
#inserts it into the pipe
#data is piping into the first argument of the function e.g. data in summarize
#data frame is a spreadsheet/ table with rows and columns where rows are observations and columns are data
#tibble is a data frame in this package
#if you use the one with the % signs you need to load tidyverse

gapminder_data %>% 
  summarize(averageLifeExp = mean(lifeExp))

#save to object
#creates a new object titled: gapminder_data_summarized
gapminder_data_summarized <- gapminder_data %>% 
  summarize(averageLifeExp = mean(lifeExp))

#What is the mean life expectancy for the most recent year
#take data and pipe it into summarize
#1st step is what is the maximum year?
gapminder_data %>% 
  summarize(recent_year = max(year))


## Filter ------------------------------------------------------------------

#2nd mean life expectancy for most recent year
#get max year in filter()
#once we have the filter, we want to summarize it (summarize collapses the rows)
#piping helps us string together function if we didn't use pipe, we would have
#had to start with summarize etc.

## Mean, Max, Min ----------------------------------------------------------

gapminder_data %>% 
  filter(year == 2007) %>% 
  summarize(average_lifeExp = mean(lifeExp))

#what is the earliest year in the dataset?

#summarize average GPD for the earliest year in the dataset

# 1) get the min year in the dataset

gapminder_data %>% 
  summarize(first_year = min(year))

gapminder_data %>% 
  filter(year == 1952) %>% 
  summarize(average_gdp = mean(gdpPercap))


# Grouping ----------------------------------------------------------------

# What is the mean life expectancy for EACH YEAR
# just "grouping" year doesn't help because it doesn't know what to group

gapminder_data %>% 
  group_by(year, country) %>% 
  summarize(average_lifeExp = mean(lifeExp))

# can now create a new object

grouped_by_year <- gapminder_data %>% 
  group_by(year, country) %>% 
  summarize(average_lifeExp = mean(lifeExp))

#find mean life expectancy for each continent

gapminder_data %>% 
  group_by(continent) %>% 
  summarize(average_lifeExp = mean(lifeExp))

#find mean life expec for each year and each continent

gapminder_data %>% 
  group_by(continent, year) %>% 
  summarize(average_lifeExp = mean(lifeExp))

#find mean life expec and mean gdp for each continent
#and add life expec

gapminder_data %>% 
  group_by(continent) %>% 
  summarize(
    average_lifeExp = mean(lifeExp),
    max_lifeExp = max(lifeExp),
    average_gdp = mean(gdpPercap)
  )

# Mutate ------------------------------------------------------------------

#mutate allows us to create a new column
#for example we can multiply year * 2 and move it before pop

gapminder_data %>% 
  mutate(double_year = year * 2, .before = pop)
  
# what is gdp not per cap?
# mult pop x gdpPercap

gapminder_data %>% 
  mutate(gdp = pop * gdpPercap)

#make a new column for population in millions

gapminder_data %>% 
  mutate(pop_in_millions = pop / 1000000, .after = pop)


## Glimpse -----------------------------------------------------------------


#can also do multiple actions in one
#glimpse allows you to view differently

gapminder_data %>% 
  mutate(
    gdp = pop * gdpPercap,
    pop_in_millions = pop / 1000000,
    .after = pop) %>% 
  glimpse()

#see mean gdp for countrys in Asia
#save as an object

gdp_countriesInAsia_summarized <- gapminder_data %>% 
  group_by(country) %>% 
  filter(continent == "Asia") %>% 
  mutate(gdp = pop * gdpPercap) %>% 
  summarize(average_gdp = mean(gdp))

#how to print your object to the console you can just write the name e.g. "gdp_countriesInAsia_summarized"
#and run that

gdp_countriesInAsia_summarized

#to change your object you can over-write it ex:
gdp_countriesInAsia_summarized <- gdp_countriesInAsia_summarized %>% 
  mutate(average_gdpInMillions = average_gdp / 1000000)


# Select ------------------------------------------------------------------

# select() chooses a subset of columns from a dataset (e.g. if we only care about some
# of the variables now)
# subtract a column with "-NAME OF COLUMN"

gapminder_data %>% 
  select(pop, year)

gapminder_data %>% 
  select(-continent, -country)

#create a tibble with country, continent, year, lifeExp
#write it in the order you want it

gapminder_data %>% 
  select(country, continent, year, lifeExp)


## Distinct and count ----------------------------------------------------------------

# distinct and count show you what is in a column/ row

gapminder_data %>% 
  distinct(continent)

gapminder_data %>% 
  count(continent)


## Starts_with, Ends_with -------------------------------------------------------------

#select helper function: starts_with()
#these are called "tidy select functions" (you can find these in the select() help)
#just looking at column names e.g. if we use "c" we would get columns "country" "contininet"

gapminder_data %>% 
  select(year, starts_with("c"))

#select columns ending in p: ends_with()

gapminder_data %>% 
  select(ends_with("p"))


# Reshaping data ----------------------------------------------------------


## Pivot_wider -------------------------------------------------------------

gapminder_data %>% 
  select(country, continent, year, lifeExp) %>% 
  pivot_wider(names_from = year, values_from = lifeExp)

#output has ' ' around years because R doesn't like when column names start with a year
#can fix this by adding a prefix like "yr" using "names_prefix"


## Names_prefix ----------------------------------------------------------------

gapminder_data %>% 
  select(country, continent, year, lifeExp) %>% 
  pivot_wider(names_from = year, 
              values_from = lifeExp,
              names_prefix = "yr")


## Joins -------------------------------------------------------------------

# use joins if you have columns in two seperate tables and you want to join them

# leftjoin(df1, df2) says that df1 is the main df and we are inputting the matching
# data from df2 into df1
# have to tell it what to match by e.g. by = ("country" = "countries")

#1st step: read in co2 data


## Renaming columns --------------------------------------------------------

co2_data <- read_csv("data/co2-un-data.csv", skip = 1) %>% 
  rename(country = '...2', year = Year)

joined <- left_join(gapminder_data, co2_data, 
                    by = c("country", "year"))


