## Script created as part of Software carpentry workshop on basic R code
## August 26-27, 2017 at the University of Arizona

#----------------------------------------------------------------------------------------
# Plotting with basic R-----
#----------------------------------------------------------------------------------------

# Something that every researcher knows is important is communicating your findings, and
# we often do that with plots. We can create fine tuned plots in R using BASE R, without
# using additional packages.

# Let's read in a dataset, called iris and take a look at it.

library(readr)
iris <- read_delim("datasets/iris.txt", delim="\t")

str(iris)
# Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	150 obs. of  5 variables:
#  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#  $ Species     : chr  "setosa" "setosa" "setosa" "setosa" ...

# This dataset has information on plants of 3 types of irises. They've measured the length
# and width of the petals of the flower and the sepals (green parts that often surround
# the flower).

# Let’s make three main kinds of plot using base R—a scatterplot, a histogram, and a
# boxplot—then we’ll make these same plots using a R package specifically designed for
# making plots and figures called ggplot.

#<< Scatterplot >> ----------------------------------------------------------------------

# The basic plot function is plot(x, y, ….) which x corresponding to your x-variable and
# y to the y-variable. Let’s plot sepal length as a function of petal length.

plot(iris$Sepal.Length, iris$Petal.Length)

# We see a scatterplot that shows there is a positive association between sepal and petal
# length. To add a linear regression line, you would need to use two commands abline()
# and lm(). lm() is used to fit linear models and uses the arguments lm(y ~ x), while
# abline will actually fit a line to the most recent plot. Let’s try it out.

plot(iris$Sepal.Length, iris$Petal.Length)
abline(lm(iris$Petal.Length ~ iris$Sepal.Length))

#<< Histogram >> ------------------------------------------------------------------------

# Plot will default to a scatterplot, but if you want a histogram then you need to use the
# type argument.

plot(iris$Sepal.Length, type = 'h')

#<< Boxplot >> --------------------------------------------------------------------------

# To make a boxplot, you can use the function boxplot(x ~ y, data = dataframe). Let’s plot
# sepal length as a function of species.

boxplot(Sepal.Length ~ Species, data = iris)

# If you ever want to change what order the categories on the x-axis are displayed in you
# would need to order the factor levels of that column.

# Plotting in base R can be flexible and you can actually do a lot with it, but many
# people find ggplot more user friendly and easier to learn. Let’s move on and learn how
# to do these plots using the ggplot package. Whichever you decide to use, there is a lot
# of help online if you need it.

#----------------------------------------------------------------------------------------
# Plotting with ggplot-----
#----------------------------------------------------------------------------------------

library(ggplot2)

ggplot(data = iris, aes(x=Petal.Length, y=Petal.Width)) + 
     geom_point()

# ggplot2 works on the idea that every plot has three essential elements:
# 1. Data: The dataset being plotted.
# 2. Aesthetics: The scales onto which we map our data.
# 3. Geometries: The visual elements used for our data.

# In other words, we have the dataset, the space onto which we will plot our data (axes),
# and the visualization we will use to plot each datapoint (scatterplot, barplot,
# boxplot). These are the 3 elements we will discuss today.

# ggplot2 makes this a little more comprehensive by adding the following:
# 1. Facets: Plotting small multiples.
# 2. Statistics: Representations of our data to aid understanding.
# 3. Coordinates: The space on which the data will be plotted.
# 4. Themes: All non-data ink.

# Let's look at some examples
# Facets:
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
     geom_point() + 
     facet_grid(.~Species)

# Statistics
ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
     geom_point() + facet_grid(.~Species) + 
     geom_smooth(method = "lm")

# Axes coordinates
ggplot(iris, aes(Sepal.Length, Sepal.Width, color=Species)) + 
     geom_jitter() + 
     coord_cartesian(xlim = c(4,6), ylim=c(2.5,4))

# Themes
ggplot(iris, aes(x=Species, y=Sepal.Width, fill=Species)) +
     geom_boxplot(alpha=0.6, width=0.5) + 
     theme_dark()

ggplot(iris, aes(x=Species, y=Sepal.Width, fill=Species)) +
     geom_boxplot(alpha=0.6, width=0.5) + 
     theme_light()

# ggplot2 is great because you can start with a small amount of code and it can expand
# rapidly to customize the plot.
ggplot(iris, aes(x=Species, y=Sepal.Width)) +
     geom_violin(alpha=0.5, show.legend = FALSE, aes(fill = Species)) + 
     stat_boxplot(geom ='errorbar', width=0.25) +
     geom_boxplot(width=0.5, show.legend = FALSE) + 
     geom_dotplot(binaxis="y", stackdir="center", 
                  position="dodge", dotsize=0.75, aes(fill=Species)) + 
     ggtitle("Sepal width for three species of iris") + 
     labs(x="Iris Species", y="Sepal Width") + 
     theme_classic() + 
     theme(axis.title = element_text(size=15),
           plot.title = element_text(size = 24, hjust = 0.5),
           axis.text = element_text(size=13, color = "black")) +
     scale_fill_manual(values = c("#3A9276","#F14705","#4F68A1")) 


# Another example of a more traditional publication ready plot. 
# See markdown for the reference link.
Normal <- c(0.83, 0.79, 0.99, 0.69)
Cancer <- c(0.56, 0.56, 0.64, 0.52)
m <- c(mean(Normal), mean(Cancer))
s <- c(sd(Normal), sd(Cancer))
d <- data.frame(V=c("Normal", "Cancer"), mean=m, sd=s)
d$V <- factor(d$V, levels=c("Normal", "Cancer"))

ggplot(d, aes(V, mean, fill=V, width=.5)) + 
     geom_errorbar(aes(ymin=mean, ymax=mean+sd, width=.2), 
                   position=position_dodge(width=.8)) + 
     geom_bar(stat="identity", position=position_dodge(width=.8), colour="black") + 
     scale_fill_manual(values=c("grey80", "white")) + 
     theme_bw() +theme(legend.position="none") + xlab("") + ylab("") + 
     theme(axis.text.x = element_text(face="bold", size=14), 
           axis.text.y = element_text(face="bold", size=14)) + 
     scale_y_continuous(expand=c(0,0), limits=c(0, 1.2), breaks=seq(0, 1.2, by=.2)) + 
     geom_segment(aes(x=1, y=.98, xend=1, yend=1.1)) + 
     geom_segment(aes(x=2, y=.65, xend=2, yend=1.1)) + 
     geom_segment(aes(x=1, y=1.1, xend=2, yend=1.1)) + 
     annotate("text", x=1.5, y=1.06, label="*")

#<< Syntax >> --------------------------------------------------------------------------

# The basic syntax of ggplot2 is to start the line with the function ggplot().
# In the parentheses, you want at minimum to name your dataset.

ggplot(iris)

# Notice that it opens the Plot window, but nothing is there. That's because we haven't
# yet told it what to do with our dataset.

# Next we have to give it the aesthetics. That is, how do we want to represent our data.

# We do this by adding an argument called aes(). Note that the aesthetics have to be
# within these parentheses.

# The most straightforward thing to add is the columns we want to plot on the axes.

ggplot(iris, aes(x=Sepal.Length))

# Notice it opens the Plot window, and there's even an axis, but no data has been plotted.
# This is because we haven't told it what kind of plot (geometry) we want.

# ggplot has several plot types, or geometries, that each start with geom_.
# The ones you'll likely use the most are:

# geom_point - scatter plots
# geom_histogram - for histograms
# geom_boxplot - for boxplots
# geom_bar - for barplots

# Let's try plotting the same thing but add the geom_point.

ggplot(iris, aes(x=Sepal.Length)) + 
     geom_point()
# Error: geom_point requires the following missing aesthetics: y

# We get an error, because scatterplots need an x and a y axis.

# We can also add another layer. We'll add one called geom_smooth, which allows us to add
# a trend line or spline.

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
     geom_point() + 
     geom_smooth()

# The default for geom_smooth() is a spline. We can do a trendline by adding an argument,
# method = "lm". Remember, you can use the help() function to find out all the options
# available for a function. Ggplot2 also has extensive and easy to understand
# documentation (see resources document).

# Note: An important point is that each "layer" of complexity is drawn "in order", meaning
# that it renders the plot in the order that you type it. This means that the last "layer"
# will lay on top of the one before it.

# Let's instead try a histogram.

ggplot(iris, aes(x=Sepal.Length)) + 
     geom_histogram()

# This one works, and you should see the histogram, which shows how many datapoints lie in
# each bin.

# Note: You also get a warning, stating that the binwidth wasn't defined, so a default was
# used.

#<< Extra options >> -------------------------------------------------------------------

#--Histogram----
# Let's start with the histogram we just made and check out a few of the features we can
# tweak.

ggplot(iris, aes(x=Sepal.Length)) +
     geom_histogram()

# If we add a grouping feature, we can change the fill color of the bars based on species.
# We do this using the fill argument.

ggplot(iris, aes(x=Sepal.Length, fill=Species)) + 
     geom_histogram()

# These histograms are stacked on each other, but what if instead we want them independent
# of each other. We can use the position argument in the geom_histogram call to fix this.
# If we change it to identity, it gives each species it's own histogram overlaid on each
# other. It's difficult to see, so I've also added the alpha argument, which changes how
# see through each layer is.

ggplot(iris, aes(x=Sepal.Length, fill=Species)) + 
     geom_histogram(position="identity", alpha=0.5)

# Let's compare this to the original plot with the layer 50% see through. 
# Notice how it's all one stacked layer.

ggplot(iris, aes(x=Sepal.Length, fill=Species)) + 
     geom_histogram(alpha=0.5)

#--Scatterplots----
# We can also change the appeal and readability of plots. Let's take a look at
# scatterplots and how we can change things to help explore our data. First, let's try
# changing the color. If we give it a continuous variable, it creates a gradient.

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Sepal.Width)) + 
     geom_point()

# If instead we give it a categorical variable, such as Species, it assigns colors.

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Species)) + 
     geom_point()

# We can also just assign a color that we like.

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color="coral")) + 
     geom_point()

#**Note: The color option is inside the aesthetics aes() function!
     
# For scatterplots, we can also assign shapes. Shapes only make sense if used with
# categorical data.

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, shape=Species)) + 
     geom_point()

# Sometimes, points stack up on each other, and we need to spread them out a bit. This is
# called overplotting, and we can address it by making the points transparent, or by
# "jittering" the points just a little so they aren't all stacked on top of each other. We
# can do this by adding a position argument to the geom_point() layer.

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, shape=Species)) + 
     geom_point(position="jitter")

# Alternately, we can use the geom_jitter geometry. It works just like the geom_point
# geometry, by moving the points a little so that you can prevent overplotting.

ggplot(iris, aes(x=Species, y=Sepal.Length)) + 
     geom_point()

ggplot(iris, aes(x=Species, y=Sepal.Length)) + 
     geom_jitter()

# We can control the amount of jitter with the width argument.

ggplot(iris, aes(x=Species, y=Sepal.Length)) + 
     geom_jitter(width=0.25)

# You can customize all of the colors and shapes instead of leaving it default. In the
# resources section of the GitHub repo, you can find information on these more advanced
# topics.

#--Boxplot----

# For a basic boxplot, you can use ‘geom_boxplot()’
ggplot(iris, aes(x=Species, y=Sepal.Length)) + 
     geom_boxplot()

# We can also change the color of a boxplot.
ggplot(iris, aes(x=Species, y=Sepal.Length, color=Species)) + 
     geom_boxplot()

# It outlined the boxes. But say we want to fill in the boxes instead. For this, we need
# to use the fill option.
ggplot(iris, aes(x=Species, y=Sepal.Length, fill=Species)) + 
     geom_boxplot()

#--Barplot----

# There are a few additional features on barplots. We'll start with a basic barplot.
ggplot(iris, aes(Petal.Width)) + 
     geom_bar()

# We get a bar for each plot. Note that this probably isn't the best way to visualize this
# data, but I just want to give you an example of ways to customize a bar plot.

# Bar plots have some additional functionality. For example, we can add an aesthetic to
# consider Species. This creates a stacked barplot.

ggplot(iris, aes(Sepal.Length, fill=Species)) + 
     geom_bar()

# Just like with the histogram, we can change how these bars lay around each other with
# the position argument, which we have to add to the geom_bar() statement

ggplot(iris, aes(Sepal.Length, fill=Species)) + 
     geom_bar(position = "dodge")

ggplot(iris, aes(Sepal.Length, fill=Species)) +
     geom_bar(position = "fill")

ggplot(iris, aes(Sepal.Length, fill=Species)) +
     geom_bar(position = "stack")

# Notice how the bars change as we change the position.

# You can continue to add elements to the graph (e.g. changing the axes and adding titles)
# by adding lines with ‘+’. Here are some basic elements you can add:
     
# xlab(label) changes x-axis label
# ylab(label) changes y-axis label
# ggtitle(label, subtitle = NULL) Adds plot title and an optional subtitle
# theme() can be used to change the background, remove grid, and change the border
# facet_grid() divides a single graph into multiple graphs in a grid based on categorical
#     data e.g. for the iris data, you could have separate graphs for each species by
#     adding
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color=Sepal.Width)) +
     geom_point() +
     facet_grid(. ~ Species) +
     xlab('Sepal length (mm)') +
     ylab('Sepal width (mm)') +
     theme_classic()

# Note: Pretty much anything that you would like to change can be. You can find numerous
# examples by googling what you want to change (e.g. google ‘remove background grid
# ggplot’). Additionally, there are resources to help you in our resources document.
