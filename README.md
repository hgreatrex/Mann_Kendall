# Mann Kendall metric analysis

Part of nt is on Knowledge Exchange - in this case how people use methods and statistics and how bad information can propagate through to actionable decisions.  In this case, I focus on the use of the Mann Kendall statistic in four ways.  Currently this readme describes my research process.  As I continue, this will start to become a more formal readme for the analysis

### 1. Understanding the Mann Kendall statistic itself

I'm first exploring at explaining the Mann Kendall test as simply as possible (at a high school level), both in terms of the test and its underlying assumptions.  This is not new research!  I'm doing it for my own benefit.  I'm then using this process to: 
 
1. Explore ways that it can be 'fooled' by common meteorological phenomena,  summarising these as a series of "red flags" and "green flags". 

2. Document terminology confusions that might lead to misuse of the test.For example statisticians use "seasonality" to mean any periodicity in the data at any time-scale
3.  Document relevant human cognitive biases that could make errors less likely to be noticed (the gamblers fallacy and cognitive memory function).

### 2. Mapping red flags in rainfall trend analysis

 We are currently in the perfect storm for accidental mis-use of trend statistics. There are now about 30-40 years of satellite weather data, so that trends are "just" about start registering as "significant" but it's still far too short to balance out data artifacts.  

 To assess the potential impact of this, I'm  planning to take all TAMSAT or CHIRPS statellite rainfall data at an Africa/Global scale and make maps of each assumption, marking out areas where there might be red flags (for example, MK shouldn't be used where there is multi-decadal periodicity) and suggesting replacements/improvements for each case study.   I expect this to lead to a meteorologial research paper. 

### 3. Assessing how Mann Kendall has been used in publishd research

This is the big bit, systematically tracking every published paper that either focuses on the test itself or uses Mann Kendall to assess weather trends. 

#### a. Systematic bibliometric tagging

I have currently collected

 - >8000 papers mentioning Mann-Kendall in the title abstract or topic, 
 - >5000 papers that mention weather trends, changes, variability etc. in the title or abstract
 
 For each paper, I'm extracting the paper text itself, then analysing all mentions of the MK statistic. For each case I'm tagging any red flags (no mentions of assumption checking, short time-series  and more),  or green flags (modified versions of the test, words like pre-whitening etc).  This will then from the basis of a neo4j knowledge graph. 

#### b. Bibliometric knowledge graphs and tracking

This will then from the basis of a neo4j knowledge graph and bibiometric tracking to assess if we can map out the paper silos or pathways of knowledge in how  Mann Kendall use. For example, prelimiary analysis shows 

  - There is a big group of papers written by and  cited by statisticians who talk about the test itself and its dangers, or propose modifications.
  - There is a group of research on satellite trends which  ignores the assumptions.  If I was cynical, I would suggest that one paper started by saying the test was "robust" and people just copy/paste that sentence then use the test all weather time-series
 - Papers that include MK in the title or abstract tend to do a good job. Papers that tend to do a bad job are those that only mention "trend" in the title/abstract and only mention MK in the article text
 
#### c. Tracking pathways to impact

I'm also seeing how this trickles through into impact.  For example I have downloaded all the citations for the IPCC report and I'm mapping those out to see if bad statistics is trickling through into systematic reviews or decision making. 

### 4. Helping people do better

I am then planning a series of public tools to support how people can use MK more appropriately in the future.  These include

 - A statistical teaching tool similar to the datasaurus/anslems quartet where I can highlight some common issues and correct terminology confusions. Rather than assumptions, I'm calling them "red flags" and linking to how people can fix them. 

 - Hopefully making a mini R-package where you can check the assumptions for a given time-series (and seeing if I can get every R function that does MK to adopt/mention it). 

 - Seeing how we can fix MK for identified research silos - for example maybe it's reaching out to IPCC authors, or journal editors with checklists, publishing the issue in the sorts of journals that particular subgroups read.

 
 ## The future

I am then planning to repeating this process for other temporal and spatial statistics, such as Thiel-Sens, PCA, wavelet analysis or spatial statistics such as, Moran's I, LISA, etc etc.

I hope that this will ultimately become a textbook - so much more fun than papers.  Or something like hyperphysics for weather/climate analysis (http://hyperphysics.phy-astr.gsu.edu/hbase/index.html) or http://www.cawcr.gov.au/projects/verification/




## Installation
Please don't!  Or talk to Helen before continuing. 


## Support
https://www.geog.psu.edu/directory/helen-greatrex


## Roadmap
I'm currently partly through sections 1 and 2. 


## Contributing
I'm not currently open to contributions or collaborations.


## Authors and acknowledgment
Main author: Dr Helen Greatrex. 

- The bibliometreic mapping builds upon the reseaerch I am conducting with Miriam Nielsen and Andrew Kruczkeweiz at Columbia University, alongside my graduate students Sophie Lelei and undergraduate student Ben Kelly at Penn State. 
- The satellite research builds upon work, mentorship and collaborations with the TAMSAT research group at the University of Reading, and the Climate Hazards Centre at UCSB.
- The project as a whole is dedicated to Dr David Grimes and Dr Roger Stern, who impressed upon me the importance of both good statistics and common-sense communication!


## License
For open source projects, say how it is licensed.

## Project status - OPEN
