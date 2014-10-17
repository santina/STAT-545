



le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(coef(the_fit), c("intercept", "slope"))
}

gd_url <- "http://tiny.cc/gapminder"
data <- read.delim(gd_url)
j_data  <- subset(data, country=="France")
library(ggplot2)
p <- ggplot(j_data, aes(x-year, y=liefExp))
p+geom_point() + geom_smooth(method="lm", se=FALSE)
j_fit <- lm(lifeExp ~ year, j_data)
coef(j_fit)
j_fit["coefficients"]
j_fit <- lm(lifeExp ~ I(year - 1952), j_data)
coef(j_fit)
lin_fit (data[data$country == "Japan", ], 1952)
setNames(coef(fit), c("Intercept", "slope")
         
#########

max_by_con  <- ddply(data, ~continent, summarize, max_le = max(lifeExp))

