library(tidyverse)

#the next line imports the data 
gapminder_1997 <- read_csv("data/gapminder_.csv")

Sys.Date()
getwd() #prints the current working directory
sum(5,6)

?round()
round(3.1415,3)
round(x=3.1415)
round(x=3.1415, digits = 2)
round(digits = 2, x=3.1415)

##########################Plotting###############################
ggplot(data=gapminder_1997) +
  aes(x=gdpPercap) + 
  labs(x= "GDP Per Capita") +
#aes gives name to x axis
#labs gives a new label to x axis
#hanging + marks lets R know to run everything that is unfinished; each + adds another layer

#map the column lifeExp to the y axis
  aes(y=lifeExp) +
  geom_point() + #geom_point used to create scatter plots
  labs(title = "Do people in wealthy countries live longer?") +
  aes(color = continent) + #encodes each continent as a dif color
  scale_color_brewer(palette = "Accent") + #changes color palette #particularly well suited to display discrete values on a map
  aes(size = pop/1000000) + # /10000000 just adds that calculation into the legend, so that we don't have that weird scientific notation
  labs(size = "Population (in millions)")
  #aes(shape = continent) #encodes each continent as a dif shape
  
  
#consolidate above code
  ggplot(data=gapminder_1997) +
  aes(x=gdpPercap, 
      y=lifeExp, 
      color = continent, 
      size = pop/1000000) + 
  labs(x= "GDP Per Capita", title = "Do people in wealthy countries live longer?", size = "Population (in millions)") +
  geom_point() + #geom_point used to create scatter plots
  scale_color_brewer(palette = "Set2") #changes color palette #particularly well suited to display discrete values on a map
  ggsave("figures/gdpPercap_lifeExp.png")
