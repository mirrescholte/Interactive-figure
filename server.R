if(!require(readxl)) install.packages(readxl)
if(!require(shiny)) install.packages(shiny)
if(!require(ggpubr)) install.packages(ggpubr)
if(!require(dplyr)) install.packages(dplyr)

# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 9MB.
options(shiny.maxRequestSize = 90*1024^2)

function(input, output) {
  Dataset <- reactive({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    data = read_excel(path = inFile$datapath,col_names = FALSE, sheet = "Scenarios" )
    dims =  dim(data)
    pointer = as.data.frame(data[1:3,])
    
    pointer = as.data.frame(apply(pointer,2,function(x)  round((as.numeric(x)),2)))
    
    which.is1 = c(input$PLND_sens,
                 input$Nano_new_Sens,
                 input$Nano_new_Spes)
    
    which.is2 = c(input$PLND_sens2,
                  input$PSMA_new_Sens,
                  input$PSMA_new_Spes)
    
    nano_col = which(apply(pointer, 2, function(x) identical(x,which.is1)))
    
    PSMA_col = which(apply(pointer, 2, function(x) identical(x,which.is2)))
    
    data1 =data[(7:dims[1]), (nano_col:(nano_col+1))]
    data2=data[(7:dims[1]), ((PSMA_col+2):(PSMA_col+3))]
    
    data1 = as.data.frame(apply(data1,2, as.numeric ))
    data2 = as.data.frame(apply(data2,2, as.numeric ))
    
    names(data1)= c("incremental_costs","incremental_QALYs")
    names(data2)= c("incremental_costs","incremental_QALYs")
    
    return(list(data1 =  data1 , data2=data2))
  })
  
  # Show table:
  output$table <- renderTable({
    
    Dataset2 = cbind(head(Dataset()$data1, n = 10),head(Dataset()$data2, n = 10) )
    
    return(Dataset2)
  })
  
  # Show plot1:
  output$plot1 <- renderPlot({
    plot_data1 = Dataset()$data1
    plot_data2 = Dataset()$data2

    
    point.estimates1 =  plot_data1[1,]
    point.estimates2 =  plot_data2[1,]
    
    plot_data1= plot_data1[4:dim(plot_data1)[1],1:2]
    plot_data2= plot_data2[4:dim(plot_data2)[1],1:2]
    
    plot_data1$treatment = rep("Nano MRI", dim(plot_data1)[1])
    plot_data2$treatment = rep("PSMA PET/CT", dim(plot_data2)[1])
    
    plot_data =  rbind(plot_data1, plot_data2)
    
    
    plot1 = ggscatter(data = plot_data,"incremental_QALYs", "incremental_costs", color = "treatment",
                      shape = input$shape, size = input$size, alpha =  input$alpha,
                      palette = c("#00AFBB", "#E7B800"), ellipse = input$ellipse,
                      mean.point = input$mPlot,
                      star.plot = input$sPlot) + 
      geom_point(data = point.estimates1 ,colour = "red")+ 
      geom_point(data = point.estimates2 ,colour = "red" )+  # this adds a red point
      geom_text(data=point.estimates1, label="nano-MRI point estimate") + # this adds a label for the red point
      geom_text(data=point.estimates2, label="PSMA PET/CT point estimates ") # this adds a label for the red point
    
    return(plot1)
  })
  
}