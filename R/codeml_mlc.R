##' read mlc file of codeml output
##'
##' 
##' @title read.codeml_mlc 
##' @param mlcfile mlc file
##' @return A \code{codeml_mlc} object
##' @export
##' @author ygc
##' @examples
##' mlcfile <- system.file("extdata/PAML_Codeml", "mlc", package="ggtree")
##' read.codeml_mlc(mlcfile)
read.codeml_mlc <- function(mlcfile) {
    tip_seq <- read.tip_seq_mlc(mlcfile)
    dNdS <- read.dnds_mlc(mlcfile)
    
    new("codeml_mlc",
        fields   = colnames(dNdS)[-c(1,2)],
        treetext = read.treetext_paml_mlc(mlcfile),
        phylo    = read.phylo_paml_mlc(mlcfile),
        dNdS     = dNdS,
        seq_type = get_seqtype(tip_seq),
        tip_seq  = tip_seq,
        mlcfile  = mlcfile)
}


##' @rdname gzoom-methods
##' @exportMethod gzoom
setMethod("gzoom", signature(object="codeml_mlc"),
          function(object, focus, subtree=FALSE, widths=c(.3, .7)) {
              gzoom.phylo(get.tree(object), focus, subtree, widths)
          })

##' @rdname groupOTU-methods
##' @exportMethod groupOTU
setMethod("groupOTU", signature(object="codeml_mlc"),
          function(object, focus) {
              groupOTU_(object, focus)
          }
          )

##' @rdname groupClade-methods
##' @exportMethod groupClade
setMethod("groupClade", signature(object="codeml_mlc"),
          function(object, node) {
              groupClade_(object, node)
          }
          )


##' @rdname scale_color-methods
##' @exportMethod scale_color
setMethod("scale_color", signature(object="codeml_mlc"),
          function(object, by, ...) {
              scale_color_(object, by, ...)
          })

##' @rdname show-methods
##' @exportMethod show
setMethod("show", signature(object = "codeml_mlc"),
          function(object) {
              cat("'codeml_mlc' S4 object that stored information of\n\t",
                  paste0("'", object@mlcfile, "'."),
                  "\n\n")
              
              cat("...@ tree:")
              print.phylo(get.tree(object))                  
              
              cat("\nwith the following features available:\n")
              cat("\t", paste0("'",
                                 paste(get.fields(object), collapse="',\t'"),
                                 "'."),
                  "\n")
          }
          )


##' @rdname get.fields-methods
##' @exportMethod get.fields
setMethod("get.fields", signature(object = "codeml_mlc"),
          function(object) {
              object@fields
          })

##' @rdname plot-methods
##' @exportMethod plot
##' @param layout layout
##' @param branch.length branch length
##' @param show.tip.label logical
##' @param position one of "branch" and "node"
##' @param annotation one of get.fields(x)
##' @param ndigits round digits
setMethod("plot", signature(x = "codeml_mlc"),
          function(x, layout        = "phylogram",
                   branch.length    = "branch.length",
                   show.tip.label   = TRUE,
                   tip.label.size   = 4,
                   tip.label.hjust  = -0.1,
                   position         = "branch",
                   annotation       = "dN_vs_dS",
                   annotation.size  = 3,
                   annotation.color = "black",
                   ndigits          = 2,
                   ...
                   ) {
              
              p <- ggtree(x, layout=layout,
                          branch.length=branch.length,
                          ndigits=ndigits, ...)
              
              if (show.tip.label) {
                  p <- p + geom_tiplab(hjust = tip.label.hjust,
                                       size  = tip.label.size)
              }
              plot.codeml_mlc_(p, position, annotation,
                               annotation.size, annotation.color)
          })


plot.codeml_mlc_<- function(p, position, annotation=NULL,
                            annotation.size, annotation.color){

    if (!is.null(annotation) && !is.na(annotation)) {
        p <- p + geom_text(aes_string(x=position,
                                      label = annotation),
                           size=annotation.size, vjust=-.5,
                           color = annotation.color)
    }
    p + theme_tree2()
}

    
##' @rdname get.tree-methods
##' @exportMethod get.tree
setMethod("get.tree", signature(object = "codeml_mlc"),
          function(object, ...) {
              object@phylo
          }
          )



