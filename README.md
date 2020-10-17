# meshRandom
Tool that simulates two-dimensional sample distribution based on a sample defined mesh  
GitHub: https://github.com/YujiSODE/meshRandom  
>Copyright (c) 2020 Yuji SODE \<yuji.sode@gmail.com\>  
>This software is released under the MIT License.  
>See LICENSE or http://opensource.org/licenses/mit-license.php  
______

<figure>
        <img width=900 src="meshRandom_IMG_sampleGraphs.png" alt="meshRandom_IMG_sampleGraphs.png">
        <figcaption>
                <b>Figure</b> <b>1.</b> Four sample data sets and simulated random coordinates.<br>
                <b>A.</b> data set model: <code><i>y</i>=3.0*<i>x</i>+5.0</code>.<br>
                <b>B.</b> data set model: <code><i>y</i>=3.0*<i>x</i>+5.0*<i>U</i></code> where <code><i>U</i></code> is random number in <code>(0,1)</code>.<br>
                <b>C.</b> data set model: <code><i>y</i>=sin(<i>x</i>)</code>.<br>
                <b>D.</b> data set model: <code>(<i>x</i>,<i>y</i>)=(0.25*cos(<i>n</i>*π/2.0),0.25*sin(<i>n</i>*π/2.0))</code> where <code><i>n</i>=0,1,2,...</code>.<br>
                <code><i>y</i>^</code> is simulated random coordinates.
        </figcaption>
</figure>

## 1. Description
Tool that simulates two-dimensional sample distribution based on a sample defined mesh.

### shell
- `tclsh meshRandom.tcl N xyList;`
### Tcl
- `::meshRandom::randoms N xyList;`

  - `$N`: number of random coordinates to return
  - `$xyList`: a list of xy-coordinate data, and every element is expressed as `x,y`

## 2. Concept
Supposing that two-dimensional sample distribution is composed of four sample points _P<sub>1</sub>_ to _P<sub>4</sub>_.  
Sample points _P_ are linked by paths _F_.  
Random coordinates _P^_ are generated along a path _F<sub>ij</sub>_.  
_P^_ is included within a distribution _P<sub>1</sub>P<sub>2</sub>P<sub>3</sub>P<sub>4</sub>_.

 <figure>
        <img width=400 src="meshRandom_IMG_conceptIMG.png" alt="meshRandom_IMG_conceptIMG">
        <figcaption>
                <b>Figure</b> <b>1.</b> Diagram showing concept of <code>meshRandom</code>.<br>
                Filled circles show sample points. Red lines show sample paths <i><code>F<sub>ij</sub></code></i> beteween two sample points <i><code>P<sub>i</sub></code></i> and <i><code>P<sub>j</sub></code></i>.
        <figcaption>
</figure>

## 3. Script
- [`meshRandom.tcl`](meshRandom.tcl)

It requires Tcl 8.6+.

## 4. Library list
- Sode, Y. 2018. lSum_min.tcl: https://gist.github.com/YujiSODE/1f9a4e2729212691972b196a76ba9bd0
- Sode, Y. 2018. lPairwise_min.tcl; the MIT License: https://gist.github.com/YujiSODE/0d520f3e178894cd1f2fee407bbd3e16
