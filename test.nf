// Define a list of flavor configurations for the workflow
flavors = [
    // High-memory, large configuration (230GB RAM, 28 CPUs)
//    [ram: 230, cpus: 28, multiply: 3],
    // High-memory, medium configuration (113GB RAM, 14 CPUs)
    [ram: 113, cpus: 14, multiply: 10],
    // Medium configuration (29GB RAM, 14 CPUs)
    [ram: 29, cpus: 14, multiply: 30],
    // Small configuration (14GB RAM, 7 CPUs)
    [ram: 14, cpus: 7, multiply: 60]
]

workflow {
    // Create a channel from the flavors list and apply transformations
    channel.from(flavors) \
    // Multiply each flavor by its "multiply" value to create multiple instances
        | flatMap { n -> (0..n.multiply).collect { [ram: n.ram, cpus: n.cpus] } } \
        | testJob 
}

process testJob {
    // Specify a Docker container for this process 
    container 'quay.io/biocontainers/megahit:1.2.9--h5b5514e_2'
    
    // Tag the process output with flavor details
    tag "CPUS: ${cpus}, RAM: ${ram} GB"
    
    // Set the number of CPUs and memory for this process
    cpus "${cpus}"
    memory "${ram} GB"

    // Results of each job are not cached
    cache false
    
    // Set a time limit for this process 
    time '120s'
    
    // Configure error handling to finish the workflow on failure
    errorStrategy 'finish'

    // Specify a scratch directory for temporary files
    scratch "/vol/scratch"
    
    // Define input and output for this process
    input:
        val x  // Accept one value (a flavor configuration) from the previous channel
    
    output:
        path("*.txt")  // Output a file with a unique name based on the task ID
    
    script:
        // Assign flavor details to local variables
        ram = x.ram
        cpus = x.cpus
        """
        # Sleep for 5 seconds
        sleep 5
        
        # Write flavor details to a file
        echo "RAM: ${ram} CPUS: ${cpus}" > "${ram}_${cpus}.txt"
        """
}
