
/**
   UPF WORKFLOW.SWIFT
   Evaluate an Unrolled Parameter File (UPF)
*/

import assert;
import io;
import json;
import files;
import string;
import sys;

report_env() "turbine" "1.0"
[
----
puts ""
puts "report_env() ..."
puts ""
global env
# puts [ array names env ]     
puts "TURBINE_HOME: $env(TURBINE_HOME)"
puts ""
set tokens [ split $env(PATH) ":" ]
foreach token $tokens {
  puts "PATH: $token"
}
puts ""
set tokens [ split $env(LD_LIBRARY_PATH) ":" ]
foreach token $tokens {
  puts "LLP: $token"
}
if [ info exists env(PYTHONHOME) ] {
  puts ""
  puts "PYTHONHOME: $env(PYTHONHOME)"
}
if [ info exists env(PYTHONPATH) ] {
  puts ""
  set tokens [ split $env(PYTHONPATH) ":" ]
  foreach token $tokens {
    puts "PYTHONPATH: $token"
  }
}
puts ""
set pythons [ exec which python python3 ]
foreach p $pythons {
  puts "PYTHON: $p"
}
puts ""
puts "report_env() done."
puts ""
----
];

report_env();

string FRAMEWORK = "keras";

// Scan command line
file   upf        = input(argv("f"));
int    benchmark_timeout = toint(argv("benchmark_timeout", "-1"));

string model_name     = getenv("MODEL_NAME");
string exp_id         = getenv("EXPID");
string turbine_output = getenv("TURBINE_OUTPUT");

// Report some key facts:
printf("UPF: %s", filename(upf));
system1("date \"+%Y-%m-%d %H:%M\"");

// Read unrolled parameter file
string upf_lines[] = file_lines(upf);

// Resultant output values:
string results[];

// Evaluate each parameter set
foreach params,i in upf_lines
{
  printf("params: %s", params);
  id = json_get(params, "id");
  // NOTE: obj() is in the obj_*.swift supplied by workflow.sh
  // id = "id_%02i"%i;
  results[i] = obj(params, id);
  assert(results[i] != "EXCEPTION", "exception in obj()!");
}

// Join all result values into one big semicolon-delimited string
string result = join(results, ";");
// and print it
printf(result);
