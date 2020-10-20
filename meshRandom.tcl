#meshRandom
#meshRandom.tcl
##===================================================================
#	Copyright (c) 2020 Yuji SODE <yuji.sode@gmail.com>
#
#	This software is released under the MIT License.
#	See LICENSE or http://opensource.org/licenses/mit-license.php
##===================================================================
#Tool that simulates two-dimensional sample distribution based on a sample defined mesh
#
#=== Synopsis ===
#+++ main script +++
#these scripts return a list of random xy-coordinate points based on a sample defined mesh
#
#*** [shell] ***
# - `tclsh meshRandom.tcl N xyList;`
#
#*** [Tcl] ***
# - `::meshRandom::randoms N xyList;`
#
# 	- $N: number of random coordinates to return
# 	- $xyList: a list of xy-coordinate data, and every element is expressed as "x,y"
#--------------------------------------------------------------------
#
#*** <namespace ::meshRandom> ***
# - `::meshRandom::setMesh xyList;`
# 	procedure that loads xy-coordinate data list to set mesh, and returns number of function paths
# 	- $xyList: a list of xy-coordinate data, and every element is expressed as "x,y"
#
# - `::meshRandom::rdmCore;`
# 	procedure that returns a random xy-coordinate point based on a sample defined mesh
#
# - `::meshRandom::randoms N xyList;`
# 	procedure that returns a list of random xy-coordinate points based on a sample defined mesh
# 	- $N: number of random coordinates to return
# 	- $xyList: a list of xy-coordinate data, and every element is expressed as "x,y"
#--------------------------------------------------------------------
#
#=== lPairwise_min.tcl (Yuji SODE, 2018); the MIT License: https://gist.github.com/YujiSODE/0d520f3e178894cd1f2fee407bbd3e16 ===
# - `lPairwise list;`
# 	it returns pairwise combination of given list
# 	- $list: list
#--------------------------------------------------------------------
#
#*** <namespace ::tcl::mathfunc> ***
#additional math function
#
#--- lSum_min.tcl (Yuji SODE, 2018): https://gist.github.com/YujiSODE/1f9a4e2729212691972b196a76ba9bd0 ---
# - `lSum(list)`: function that returns sum of given list
# 	- `$list`: a numerical list
##===================================================================
#
set auto_noexec 1;
package require Tcl 8.6;
#--------------------------------------------------------------------
#
#=== lPairwise_min.tcl (Yuji SODE, 2018); the MIT License: https://gist.github.com/YujiSODE/0d520f3e178894cd1f2fee407bbd3e16 ===
#It returns pairwise combination of given list
proc lPairwise {list} {set n [llength $list];set i 1;set LIST {};while {$n>1} {set i 1;while {$i<$n} {lappend LIST [list [lindex $list 0] [lindex $list $i]];incr i 1;};set list [lrange $list 1 end];set n [llength $list];};return $LIST;};
#--------------------------------------------------------------------
#
#additional math function
#*** <namespace ::tcl::mathfunc> ***
#=== lSum_min.tcl (Yuji SODE, 2018): https://gist.github.com/YujiSODE/1f9a4e2729212691972b196a76ba9bd0 ===
#Additional mathematical function for Tcl expressions
# [Reference]
# - Iri, M., and Fujino., Y. 1985. Suchi keisan no joshiki (in Japanese). Kyoritsu Shuppan Co., Ltd.; ISBN 978-4-320-01343-8
proc ::tcl::mathfunc::lSum {list} {namespace path {::tcl::mathop};set S 0.0;set R 0.0;set T 0.0;foreach e $list {set R [+ $R [expr double($e)]];set T $S;set S [+ $S $R];set T [+ $S [expr {-$T}]];set R [+ $R [expr {-$T}]];};return $S;};
#--------------------------------------------------------------------
#
#*** <namespace ::meshRandom> ***
namespace eval ::meshRandom {
	#=== variables ===
	#
	#list of function parameters
	#single model: y = a*x+b := "a b x1 x2"
	#y=f(x)=0*x+max($y1,$y2) when $x1=$x2
	variable FUNCS {};
	#
	#=== Machine epsilon ===
	variable EPS 1.0;
	while {1.0+$EPS!=1.0} {
		set EPS [expr {$EPS/2.0}];
	};
};
#
#procedure that loads xy-coordinate data list to set mesh, and returns number of function paths
proc ::meshRandom::setMesh {xyList} {
	# - $xyList: a list of xy-coordinate data, and every element is expressed as "x,y"
	#
	variable ::meshRandom::FUNCS;variable ::meshRandom::EPS;
	###
	#
	set ::meshRandom::FUNCS {};
	###
	#
	#error is returned when size of xy-coordinate data is less than 2
	if {[llength $xyList]<2} {error "ERROR: size of xy-coordinate data is less than 2"};
	#
	#single model: y = a*x+b
	set dx [expr {double(0)}];
	set dy [expr {double(0)}];
	#
	set e1 {};
	set e2 {};
	set x1 [expr {double(0)}];
	set y1 [expr {double(0)}];
	set x2 [expr {double(0)}];
	set y2 [expr {double(0)}];
	#
	foreach e [lsort -unique [lPairwise $xyList]] {
		#$e is {x1,y1 x2,y2}
		set e1 [split [lindex $e 0] ,];
		set e2 [split [lindex $e 1] ,];
		#
		set x1 [expr {double([lindex $e1 0])}];
		set y1 [expr {double([lindex $e1 1])}];
		set x2 [expr {double([lindex $e2 0])}];
		set y2 [expr {double([lindex $e2 1])}];
		#
		#$dx=$x2-$x1
		set dx [expr {$x2!=$x1?lSum("$x2 -$x1"):$::meshRandom::EPS}];
		#
		#$dy=$y2-$y1
		set dy [expr {$x2!=$x1?lSum("$y2 -$y1"):0.0}];
		#
		#single model: y = a*x+b := "a b x1 x2"
		#y=f(x)=0*x+max($y1,$y2) when $x1=$x2
		#
		lappend ::meshRandom::FUNCS "[expr {$dy/$dx}] [expr {$x2!=$x1?lSum("$y1 -$dy*$x1/$dx"):max($y1,$y2)}] $x1 $x2";
	};
	#
	#number of function paths is returned
	return [llength $::meshRandom::FUNCS];
};
#
#procedure that returns a random xy-coordinate point based on a sample defined mesh
proc ::meshRandom::rdmCore {} {
	variable ::meshRandom::FUNCS;
	###
	#
	#error is returned when sample defined mesh is not defined
	if {[llength $::meshRandom::FUNCS]<1} {error "ERROR: sample defined mesh is not defined"};
	#
	#random values
	set r1 [expr {int(floor([llength $::meshRandom::FUNCS]*rand()))}];
	set r2 [expr {rand()}];
	#
	#function parameters: $a and $b
	set a [expr {double([lindex $::meshRandom::FUNCS $r1 0])}];
	set b [expr {double([lindex $::meshRandom::FUNCS $r1 1])}];
	#
	#range of x: [$minX,$maxX]
	set minX [expr {double(min([lindex $::meshRandom::FUNCS $r1 2],[lindex $::meshRandom::FUNCS $r1 3]))}];
	set maxX [expr {double(max([lindex $::meshRandom::FUNCS $r1 2],[lindex $::meshRandom::FUNCS $r1 3]))}];
	#
	#$rX is random values in the range of ($minX,$maxX)
	#$rX = $minX+($maxX-$minX)*$r2
	set dx [expr {lSum($maxX-$minX)}];
	#
	set rX [expr {lSum("$minX $dx*$r2")}];
	#
	unset r1 r2 minX maxX dx;
	return "$rX,[expr {lSum("$b $a*$rX")}]";
};
#
#procedure that returns a list of random xy-coordinate points based on a sample defined mesh
proc ::meshRandom::randoms {N xyList} {
	# - $N: number of random coordinates to return
	# - $xyList: a list of xy-coordinate data, and every element is expressed as "x,y"
	###
	set N [expr {$N<1?1:int(abs($N))}];
	set l {};
	set i 0;
	#
	#setting sample defined mesh
	::meshRandom::setMesh $xyList;
	#
	while {$i<$N} {
		lappend l [::meshRandom::rdmCore];
		incr i 1;
	};
	#
	return $l;
};
#
#=== shell ===
#`tclsh meshRandom.tcl N xyList;`
if {$argc>1} {
	puts stdout [::meshRandom::randoms [lindex $argv 0] [lindex $argv 1]];
};
