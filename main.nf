// mi_to_preprocessing
nextflow.enable.dsl = 2

include { filtering_collapsing } from "./subworkflows/filtering_collapsing/main"

//

// Path of fastq R1 and R2
    
channel_i=Channel
    .fromPath("${params.path_data}/*", type:'dir')
    .map{ tuple(it.getName(), it.toString()) }


// Add view to print the contents of channel_i
channel_i.view { "Contents of channel_i: $it" }

//

//----------------------------------------------------------------------------//
// global pipeline
//----------------------------------------------------------------------------//



//

workflow {

    filtering_collapsing(channel_i)
    filtering_collapsing.out.tsv.view()

}
