fluidPage(
  titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose file to upload',
                accept = c(
                  'text/csv',
                  'text/comma-separated-values',
                  'text/tab-separated-values',
                  'text/plain',
                  '.csv',
                  '.tsv',
                  '.xlsx',
                  '.xlsm'
                )
      ),
      tags$hr(),
      p()
    ),
    mainPanel(
      
    )
  )
,
  # App title ----
  titlePanel("Choose your combination"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar to demonstrate various slider options ----
    sidebarPanel(
      
      # Input: Sensitivity of PLND with step value  0.05----
      sliderInput("PLND_sens", "Sensitivity of PLND:",
                  min = 0, max = 1,
                  value = 1, step = 0.05),      # Input: Sensitivity of the new test with step value  0.05----
      sliderInput("Nano_new_Sens", "Sensitivity of Nano_MRI:",
                  min = 0, max = 1,
                  value = 1, step = 0.05),
      # Input: Sensitivity of the new test with step value  0.05----
      sliderInput("Nano_new_Spes", "Specificity of Nano_MRI:",
                  min = 0, max = 1,
                  value = 0.95, step = 0.05),
      # Input: Sensitivity of PLND with step value  0.05----
      sliderInput("PLND_sens2", "Sensitivity of PLND:",
                  min = 0, max = 1,
                  value = 1, step = 0.05),
      # Input: Sensitivity of the new test with step value  0.05----
      sliderInput("PSMA_new_Sens", "Sensitivity of PSMA PET/CT:",
                  min = 0, max = 1,
                  value = 1, step = 0.05),

      # Input: Sensitivity of the new test with step value  0.05----
      sliderInput("PSMA_new_Spes", "Specificity of PSMA PET/CT:",
                  min = 0, max = 1,
                  value = 0.95, step = 0.05),
      # Input: The size of points in the ggplot----
      sliderInput("size", "size of points",
                  min = 0, max = 10,
                  value = 3, step = 1),
      # Input: The transparency of points in the ggplot----
      sliderInput("alpha", "size of points",
                  min = 0, max = 1,
                  value = 0.95, step = 0.05),
      # Input: The transparency of points in the ggplot----
      sliderInput("shape", "Shape of points",
                  min = 0, max = 21,
                  value = 21, step = 1), 
      checkboxInput("ellipse", "Ellipse", FALSE), 
      checkboxInput("mPlot", "Mean plot", FALSE), 
      checkboxInput("sPlot", "Star Plot", FALSE)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Table summarizing the values entered ----
      tableOutput('table'),
      plotOutput("plot1"),
      plotOutput("plot2")
      
      
    )
  )
)

