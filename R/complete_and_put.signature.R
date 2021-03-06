#' gets you an overlap of gene list with your object
#'
#' This function allows you to calculate an average expression for the list of genes of your interest.
#'
#' @param markers yout gene set, it can be a set of markers for cell type identification or genes involved in the certain pathway that you want localise
#'
#' @param Seurat_obj your Seurat object
#'
#' @return overlapping gene list
#'
#' @keywords GO, KEGG, HPA, single cell, RNA-seq
#'
#' @examples
#'
#' Ccl19hi.TRC <- complete(rodda$Ccl19hi.TRC, PP.combined)
#'
#' @export
#'

complete <- function(markers, Seurat_obj) {
  markers <-  as.character(markers[complete.cases(markers)])
  markers[markers %in% rownames(Seurat_obj@assays$RNA@data)]
}

#' Calculate average expression for gene set.
#'
#' This function allows you to calculate an average expression for the list of genes of your interest.
#'
#' @param markers yout gene set, it can be a set of markers for cell type identification or genes involved in the certain pathway that you want localise
#'
#' @param Seurat_obj your Seurat object
#'
#' @param title the name of your gene set
#'
#' @return Seurat object with new feature, your gene set average expression
#'
#' @keywords GO, KEGG, HPA, single cell, RNA-seq
#'
#' @examples
#'
#' Seurat_obj <- put_signature(markers = c("CCL21", "CCL19", "TNFSF13B"),
#'                           Seurat_obj = Seurat_obj,
#'                            title = "T-zone markers")
#'
#' ## to plot it use FeaturePlot function with min and ,ax cutoff parameters being q3 and q97, it helps you to vizualise it without noise
#'
#' FeaturePlot(Seurat_obj,
#'             "T-zone markers",
#'              cols.use = c("grey", "blue"),
#'              min.cutoff = "q3",
#'              max.cutoff = "q97")
#'
#'
#' @export
#'

# put gene signatures as new rows to the gene_cell matrix and
put_signature <- function(markers, Seurat_obj, title){
  library(Seurat)
  ### function to have a complete list of markers
  ### convert it to complete list
  markers <- complete(markers, Seurat_obj)
  DefaultAssay(Seurat_obj) <- 'RNA'
  ### function to have the average quantification for all your markers
  markers_expr <- function(Seurat_obj, markers) {
    q <- AddModuleScore(Seurat_obj, markers)
    q <- q@meta.data[grepl("Cluster" ,colnames(q@meta.data))]
    #rowSums(q) / nrow(q)
    rowSums(q) #/ median(rowSums(q))
    #scale(rowSums(q))[,1]
  }
  ### put this quantifications to the matrix on Seurat object, among the genes
  Seurat_obj@assays$RNA@data <- rbind(markers_expr(Seurat_obj, markers),
                    Seurat_obj@assays$RNA@data)
  ### name it
  rownames(Seurat_obj@assays$RNA@data)[1] <- title
  ### return the object with it
  Seurat_obj
}



