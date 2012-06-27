#!/bin/bash
mongo <<EOF
use standards
x = {"name" : "Desktop Operating System",
"current" : "Windows 7",
"emerging" : "Windows 8",
"deprecated" : "Windows XP",
"obsolete" : "Windows 2000",
"tags" : ["Desktop","OS"],
"updated" : ISODate("2012-06-21T19:10:51.946Z"),
"notes" : "Common Desktop rollout will be 64-bit Windows 7" }
db.standards.save(x)
EOF
