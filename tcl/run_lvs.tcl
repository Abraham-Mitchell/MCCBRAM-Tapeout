# ==========================================
# MAGIC + NETGEN LVS SCRIPT (SKY130)
# ==========================================

# SETTINGS
# Change this to your layout's top-level cell name.
set topCell <cell name>

# Change this to your setup path
set setupFile "/home/atm015/pdks/sky130A/libs.tech/netgen/sky130A_setup.tcl"

# Output files
# Change this to where you want your outputs stored
set outputDir "/home/atm015/mcmaster/lvs_results"
file mkdir $outputDir

set layoutSpice "$outputDir/${topCell}_extracted.spice"
set reportFile "$outputDir/lvs_report.log"
set consoleLog "$outputDir/netgen_console.log"

# ==========================================
# SELECT REFERENCE SPICE FILE
# ==========================================

set referenceSpice [tk_getOpenFile \
    -title "Select Reference SPICE File" \
    -filetypes {
        {{SPICE Files} {.sp .spice .cir .cdl}}
        {{All Files} *}
    }]

if {$referenceSpice eq ""} {
    error "LVS cancelled: No SPICE file selected."
}

if {![file exists $setupFile]} {
    error "SKY130 Netgen setup file not found."
}

puts "================================"
puts "STARTING LVS"
puts "Layout cell: $topCell"
puts "Reference: $referenceSpice"
puts "================================"

# ==========================================
# EXTRACT LAYOUT NETLIST
# ==========================================

puts "Extracting layout..."

extract do local
extract all
ext2spice lvs
ext2spice -o $layoutSpice

if {![file exists $layoutSpice]} {
    error "Layout SPICE extraction failed."
}

puts "Extraction complete."
puts "Extracted: $layoutSpice"


# ==========================================
# RUN NETGEN LVS
# ==========================================

puts "\n================================"
puts "RUNNING NETGEN LVS"
puts "================================"

set layoutArg [list $layoutSpice $topCell]
set referenceArg [list $referenceSpice $topCell]

set command [list netgen -batch lvs \
    $layoutArg \
    $referenceArg \
    $setupFile \
    $reportFile]

# Execute Netgen and capture stdout/stderr
set status [catch {
    exec {*}$command 2>@1
} output]

# Save complete console output
set fp [open $consoleLog w]
puts $fp $output
close $fp

# Print Netgen output to Magic console
puts "\n========== NETGEN OUTPUT =========="
puts $output
puts "==================================="

# Print LVS report to Magic console
if {[file exists $reportFile]} {
    set fp [open $reportFile r]
    set report [read $fp]
    close $fp

    puts "\n========== LVS REPORT =========="
    puts $report
    puts "================================"
} else {
    puts "ERROR: LVS report was not generated."
}

# Report execution status
if {$status != 0} {
    puts "\nERROR: Netgen execution failed."
} else {
    puts "\nNetgen execution completed."
    puts "Check the output above for LVS mismatches."
}
