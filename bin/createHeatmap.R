################################################
## LOAD LIBRARIES                             ##
################################################
################################################

library(optparse)
library(ggplot2)
library(RColorBrewer)
library(pheatmap)

################################################
################################################
## PARSE COMMAND-LINE PARAMETERS              ##
################################################
################################################
option_list <- list(
  make_option(c("-i", "--input_file"), type="character", default=NULL, metavar="path", help="Input sample file"),
  make_option(c("-g", "--geneFunctions_file"), type="character", default=NULL, metavar="path", help="Gene Functions file."),
  make_option(c("-a", "--annoData_file"), type="character", default=NULL, metavar="path", help="Annotation Data file."),
  make_option(c("-p", "--outprefix"), type="character", default='projectID', metavar="string", help="Output prefix.")
)


opt_parser <- OptionParser(option_list=option_list)
opt        <- parse_args(opt_parser)

sampleInput=opt$input_file
geneInput=opt$geneFunctions_file
annoInput=opt$annoData_file
outprefix=opt$outprefix

testing="Y"
if (testing == "Y"){
  sampleInput="sampleData.csv"
  geneInput="geneFunctions.csv"
  annoInput="annoData.csv"
  outprefix="test"
}


if (is.null(sampleInput)){
  print_help(opt_parser)
  stop("Please provide an input file.", call.=FALSE)
}

################################################
################################################
## READ IN FILES##
################################################
################################################
sampleData=read.csv(sampleInput,row.names=1)
annoData=read.csv(annoInput,row.names=1)
geneFunctions=read.csv(geneInput,row.names=1)

################################################
################################################
## Set colors##
################################################
################################################
annoColors <- list(
  gene_functions = c("Oxidative_phosphorylation" = "#F46D43",
                     "Cell_cycle" = "#708238",
                     "Immune_regulation" = "#9E0142",
                     "Signal_transduction" = "beige", 
                     "Transcription" = "violet"), 
  Group = c("Disease" = "darkgreen",
            "Control" = "blueviolet"),
  Lymphocyte_count = brewer.pal(5, 'PuBu')
)

################################################
################################################
## Create a basic heatmap##
################################################
################################################
pheatmap(
  sampleData,
  main="Basic Heatmap",
  clustering_distance_rows = "euclidean",
  clustering_distance_columns = "euclidean",
  clustering_method = "ward.D",
  filename="basic_heatmap_{projectID}.pdf")


################################################
################################################
## Create a basic heatmap##
################################################
################################################
pheatmap(
  sampleData,
  main="Complex Heatmap",
  clustering_distance_rows = "euclidean",
  clustering_distance_columns = "euclidean",
  clustering_method = "ward.D",
  legend_breaks = c(-3,0,2), # scale values
  legend_labels = c('low','medium','high'), # set scale labels
  annotation_colors = annoColors, # Apply annotation colors
  annotation_col=annoData, # Add annotation data
  annotation_names_col=FALSE, # Remove the title from the column annotations
  annotation_row=geneFunctions,# Add row annotations
  annotation_names_row=FALSE,# Remove the title from the row annotations
  filename="complex_heatmap_{projectID}.pdf")