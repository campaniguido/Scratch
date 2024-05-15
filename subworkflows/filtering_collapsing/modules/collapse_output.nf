// COLLAPSE_OUTPUT  module

nextflow.enable.dsl = 2

process COLLAPSE_OUTPUT {
 
    tag "${cells}"
 
    input:
        path(files)
 
    output:
        path("cells.tsv.gz"), emit: tsv
 
    script:
    """
    outfile="cells.tsv"
    files=(${files})
    cat "\${files[0]}" > \$outfile
    for f in "\${files[@]:1}"; do
        tail -n +2 "\$f" >> \$outfile
    done
    gzip --fast \$outfile
    """
 
}