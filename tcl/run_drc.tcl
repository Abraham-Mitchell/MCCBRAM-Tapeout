select top cell
box
drc on
drc check
drc catchup

puts "========================="
puts "DRC COMPLETE"
puts "Errors: [drc listall count total]"
puts "========================="

# Print actual DRC violations
set errors [drc listall why]

foreach {rule locations} $errors {
    puts "Violation: $rule"
    puts "Locations: $locations"
    puts "-------------------------"
}
