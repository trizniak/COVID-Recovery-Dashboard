**Knowledge Base** {.tabset .tabset-pills}
================

## Links to relevant articles

-----

* **Colors**
  + [HTML color codes](https://htmlcolorcodes.com/)
  + [R colors](http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf)
* **RMarkdown**
  + [**Basic Syntax**](https://www.markdownguide.org/basic-syntax/)
  + [<span style="color:DarkRed">Dynamic Title</span>](https://stackoverflow.com/questions/52540279/dynamic-rmarkdown-title-from-r-code-chunk)
  + [Unicode characters](https://jrgraphix.net/r/Unicode)
  + [Repeating child block with changing variable value](https://gist.github.com/rmoff/a043676a2f084b81a434)
* **Plotly**
  + [Linking two charts : Interactive data visualization](https://s3.amazonaws.com/assets.datacamp.com/production/course_7193/slides/chapter3.pdf)
  + [Set hovermode to *compare data on hover*](https://stackoverflow.com/questions/46730394/r-set-plotly-hovermode-to-compare-data-on-hover)
  + [Multiple filters and drop down menus](https://stackoverflow.com/questions/51718742/multiple-filters-and-drop-down-menus-for-plotly-in-r)
  + [Customize ModeBar buttons](https://stackoverflow.com/questions/37437808/how-to-custom-or-display-modebar-in-plotly)
* **DataTable (DT)**
  + [Bi-directional Color Bar](https://stackoverflow.com/questions/33521828/stylecolorbar-center-and-shift-left-right-dependent-on-sign)


## Code snippets  {.tabset .tabset-dropdown}

### [RMarkdown] <span style="color:DarkRed">Dynamic Title</span>

      ---
      output: html_document
      title: '`r days <- 60; paste0(days, " Days")`' # note the ; between lines of code
      ---
      
      -------------
      SOURCE : https://stackoverflow.com/questions/52540279/dynamic-rmarkdown-title-from-r-code-chunk


### [Plotly] Customize ModeBar buttons

      ggplotly() %>% config(displaylogo=FALSE,  
          modeBarButtonsToRemove=list(  
          "sendDataToCloud",  
          "toImage",  
          "autoScale2d",  
          "resetScale2d",  
          "hoverClosestCartesian",  
          "hoverCompareCartesian",
          "zoom2d",
          "pan2d",
          "select2d",
          "lasso2d",
          "zoomIn2d",
          "zoomOut2d"))  
      modeBarButtonsToAdd=list()
 

### [Crosstalk] Checkbox filters

      bscols(widths=c(...,NA),
       list(filter_checkbox(id="...",label="...",
                            sharedData=...,group=~...,inline=FALSE)),
       ggplotly(...))


### [Multi-Dimensional Scaling]

      # Classical MDS
      # N rows (objects) x p columns (variables)
      # each row identified by a unique row name

      d <- dist(mydata) # euclidean distances between the rows
      fit <- cmdscale(d,eig=TRUE, k=2) # k is the number of dim
      fit # view results

      # plot solution
      x <- fit$points[,1]
      y <- fit$points[,2]
      plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2",
        main="Metric MDS", type="n")
      text(x, y, labels = row.names(mydata), cex=.7)
      
      -------------
      SOURCE : https://www.statmethods.net/advstats/mds.html


### [DataTable (DT)] Bi-directional Color Bar

      make a custom styleColorBar function that uses the CSS gradients (same as the original styleColorBar) to make the kind of bars you want.
      ! ! ! adding new lines breaks the CSS):
      color_from_middle <- function (data,color1,color2) {
      max_val=max(abs(data))
      JS(sprintf("isNaN(parseFloat(value)) || value < 0 ? 'linear-gradient(90deg, transparent, transparent ' + (50 + value/%s * 50) + '%%, %s ' + (50 + value/%s * 50) + '%%,%s  50%%,transparent 50%%)': 'linear-gradient(90deg, transparent, transparent 50%%, %s 50%%, %s ' + (50 + value/%s * 50) + '%%, transparent ' + (50 + value/%s * 50) + '%%)'",
      max_val,color1,max_val,color1,color2,color2,max_val,max_val))
      }
      
      Using some test data:
      data <- data.frame(a=c(rep("a",9)),value=c(-4,-3,-2,-1,0,1,2,3,4))
      datatable(data) %>%
      formatStyle('value',background=color_from_middle(data$value,'red','blue'))
      
      -------------
      SOURCE : https://stackoverflow.com/questions/33521828/stylecolorbar-center-and-shift-left-right-dependent-on-sign


### Regression by groups

      data = data %>%
        group_by(...) %>%
        do({
          mod=lm(var.Y~var.X, data=.)
          data.frame(slope=coef(mod)[2])
          }) %>%
        right_join(data)
