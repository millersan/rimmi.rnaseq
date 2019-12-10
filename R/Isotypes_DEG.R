#' This function allows you to calculate DEG for the IG Isotypes
#'
#'
#' @param Seurat_obj Seurat object with integrated data from VDJ analysis with Isotype assigment 
#'
#'
#' @keywords DEG, single cell, VDJ analysis, B cells, T cells
#'
#' @examples
#'
#' Isotypes_DEG(A07)
#'
#' @export
#'

Isotypes_DEG <- function(Seurat_obj){
  library(Seurat)
  
  # replace cell identity from cluster to isotype
  Seurat_obj@ident <- factor(Seurat_obj@meta.data$c_gene_short)
  names(Seurat_obj@ident) <- rownames(Seurat_obj@meta.data)
  
  short_isotypes <- grep('IGH[A-Z]', levels(Seurat_obj@ident), value = T)
  
  Seurat_obj_sub <- SubsetData(object = Seurat_obj, 
                               ident.use = short_isotypes
                               )
  print('calculating markers for short isotypes')
  print(grep('IGH[A-Z].*', levels(Seurat_obj_sub@ident), value = T))
  Short_iso_markers <- FindAllMarkers(object = Seurat_obj_sub, 
                                      only.pos = F, 
                                      min.pct = 0.25, 
                                      thresh.use = 0.25)
  
  rimmi.rnaseq::markers_to_xls(Short_iso_markers, filename = 'Short_isotypes_DEGs')
  print('saved short isotypes as an excel spreadsheet')
  
  # replace cell identity from cluster to isotype
  Seurat_obj@ident <- factor(Seurat_obj@meta.data$c_gene)
  names(Seurat_obj@ident) <- rownames(Seurat_obj@meta.data)
  
  full_isotypes <- grep('IGH[A-Z].*', levels(Seurat_obj@ident), value = T)
  
  Seurat_obj_sub <- SubsetData(Seurat_obj, 
                               ident.use = full_isotypes
                               )
  print('calculating markers for short isotypes')
  print(grep('IGH[A-Z].*', levels(Seurat_obj_sub@ident), value = T))
  Full_iso_markers <- FindAllMarkers(object = Seurat_obj_sub, 
                                      only.pos = F, 
                                      min.pct = 0.25, 
                                      thresh.use = 0.25)
  
  rimmi.rnaseq::markers_to_xls(Full_iso_markers, filename = 'Full_isotypes_DEGs')
  print('saved full isotypes as an excel spreadsheet')
}  