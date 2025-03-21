![](media/image1.png)

FAIR workflow for Sentinel-1 based Deforestation Detection

**MID TERM REPORT**

presented by  
Daniel Loos, Felix Cremer, Gregory Duveiller and Fabian Gans

from the  
Max Planck Institute for Biogeochemistry

as part of the ESA initiative

Science Result Long-Term Availability & Reusability Demonstrators

in ESA contract  
4000144670/24/I-EB

from 4 September 2024 to 4 September 2025  
as of 21 March 2025

![](media/logos.png)

# Executive Summary

Earth science plays a crucial role in enhancing our understanding of our living planet, enabling us to address contemporary challenges effectively. To maximize the impact of research projects, adherence to FAIR (Findable, Accessible, Interoperable, and Reusable) and open principles is essential, as these principles help overcome barriers to data reuse. The processing of large datasets, such as satellite imagery, is made efficient and scalable through cloud environments, allowing researchers to execute workflows on demand. This necessitates that workflows be interoperable.

In this report, we present the progress of our FAIRSenDD project, which focuses on developing a FAIR workflow for Sentinel-1 based Deforestation Detection. The project's aim is to create a service on an existing cloud platform, leveraging an existing science product. This project is part of the ESA Science initiative of Long-Term Availability & Reusability Demonstrators.

Following the kickoff meeting on September 4, 2024, we are currently in the sixth month of a twelve-month timeline. Key achievements include the transformation of the original code into a Julia package, RQADeforestation.jl, and the development of a standardized workflow in the Common Workflow Language, compliant with the OGC Best Practice for Earth Observation Application Package. We have implemented unit and integration tests to ensure code correctness, automated through Continuous Integration (CI). EODC was selected as a cloud provider from the Network of Resources, and compute and storage resources were created for running CI workflows. Collaboration with external code review expert Stephan Sahm from jolin.io has been very helpful. We achieved a 27% increase in processing speed and a 63% reduction in memory usage on a 15000x15000 Equi7Grid tile. Bug fixes, including the handling of missing values, have been addressed. Documentation of code and scientific background is available at http://fairsendd.eodchosting.eu/. A talk has been submitted to the Living Planet Symposium in June 2025. We have completed WP1 (cloud provider selection) and WP2 (workflow creation) and are currently working on WP3 (Code enhancement).

Major challenges included successfully reducing additional memory allocations of the underlying algorithm and integrating bash, Julia, Python, and Docker within the same reproducible documentation. We addressed issues related to Docker startup time, OGC API response, and data loading, with optimizations focused on large datasets. Calling the Julia library directly remain an option.

Looking ahead, WP3 (code enhancement) is scheduled for completion by the end of June 2025. Subsequently, the workflow will be integrated and deployed within the infrastructure of the selected cloud provider EODC. The project is slated to conclude with a final review in September 2025.

# Introduction

## Background

Science is a cumulative endeavor, relying heavily on the foundation laid by previous research results. To facilitate this progression, it is imperative that scientific workflows adhere to the FAIR principles, ensuring they are Findable, Accessible, Interoperable, and Reusable [Wilkinson et al 2016](https://www.nature.com/articles/sdata201618).
This approach allows for the extension and reuse of workflows by other researchers, fostering collaboration and innovation. Merely implementing an algorithm is insufficient; there is a critical need for the long-term availability of these workflows to ensure their utility and impact over time. In response to this need, EarthCODE is actively developing a portal designed to host scientific workflows constructed in accordance with FAIR principles. Our project is one of the examples that can be added to the EearthCode workflow catalog. This initiative holds significant importance and relevance to the mission of ESA, as it aligns with broader environmental and regulatory goals. For instance, the Regulation on Deforestation-free Products (EUDR) aims to ensure that products consumed by EU citizens do not contribute to deforestation or forest degradation [(Eu comission 2023)](https://environment.ec.europa.eu/topics/forests/deforestation/regulation-deforestation-free-products_en). This regulation underscores the necessity for freely accessible monitoring tools capable of detecting changes in forest cover, thereby supporting sustainable practices and compliance with environmental standards.
In the past, we developed an initial software product to detect forest change using recurrence quantification analysis (RQA) of Sentinel-1 time series datasets [(Cremer et al. 2023)](https://doi.org/10.1109/JSTARS.2020.3019333).
Now, we are turning this code into a FAIR workflow, improving its performance, and extent the documentation.

## Objectives

The main objective of this project is to turn the initial software product to an end-to-end FAIR open science workflow. In particular, the objectives are as follows:

- make the workflow accessible in an interoperable format, i.e. as openEO processes graphs or packaged using OGC Best Practices.
- create a Software as a Service (SaaS), i.e. host the workflow on a cloud infrastructure, ensuring that the workflow is available and discoverable
- release code and documentation under a permissive open-source license in a public repository

# Methodology

## Initial implementation

Forests play an important role in the carbon, water and energy cycles,
thereby interacting with climate through both biogeochemical and
biophysical mechanisms (Bonan 2008). They also provide a series of
ecosystem services to human populations in addition to materials such as
wood, food, fuel and fiber, plus they harbour vast reservoirs of
biodiversity. Changes in the forest cover, and particularly those
generating forest cover loss, are particularly important to monitor to
ensure policies can be enforced to maintain the sustainability of these
ecosystem services provided by forests. Analysing satellite imagery is a
feasible and objective way to quantify the extent of deforestation.
Unlike optical imaging, Synthetic Aperture Radar (SAR) technology allows
to detect deforestation in cloudy ecosystems like rain forests as well.
However, forest properties depend drastically on the biome, making it
challenging to apply the same algorithm globally. Compared to the
analysis of individual scenes, the detection accuracy can be increased
by analysing an entire time series for single locations at once [(Cremer et al. 2023)](https://doi.org/10.1109/JSTARS.2020.3019333). This means the dataset is not seen and analysed as a
collection of images but rather as a collection of single-pixel time
series. However, analysing data which is archived as individual images
in a timeseries-first manner imposes some technical requirements on the
processing engine, including very efficient memory management. In the
past the consortium had good experiences using the YAXArrays.jl toolbox
for complex pixel-based time series analysis on large EO which is why
the mature scientific experiment was implemented in the Julia
programming language and using YAXArrays.jl for scaling the computation
and IO.

We used RQA to generate an indicator of change in the Sentinel-1 time
series. This change indicator is computed for the time series of every
pixel separately and therefore follows the “time first space later”
approach. The Recurrence Quantification Analysis is based on the
recurrence plot technique, which was first described in
[(Eckmann et al.)](https://iopscience.iop.org/article/10.1209/0295-5075/4/9/004). The recurrence plot is derived by comparing every
pairwise combination of time steps in the time series according to some
similarity measure. This leads to a quadratic binary matrix with true
values indicating that two time steps are similar, while false values
indicate they are distinct.

![
Recurrence Plots for (a) the sum of two sine waves with
different frequencies, (b) a step function with noise, and (c) a sine
wave with trend. The upper row shows the raw example time series and the
lower row the corresponding recurrence plot
](media/image3.png)

From the recurrence plot of a time series we can derive different RQA
metrics that describe the behaviour of the time series. The metric that
is used in this project for the detection of change in the behaviour of
the Sentinel-1 time series is the Trend. The RQA Trend represents the
linear regression coefficient of the recurrence rate along a diagonal in
comparison to the distance to the main diagonal. Therefore, it indicates
how much the likelihood of two time steps being similar depends on their
temporal distance.

The methodology has been validated on small scales and we compared
against a simple threshold approach on the range between the 95th to
5th percentile. We showed that the RQA Trend and the percentile range
have a similar detection rate of deforestation in a single year, but
that the percentile range of a deforestation event from previous years
can have similar values to a new deforestation which is not the case for
the RQA Trend metric.

![
  Detected Deforestation events and their timing [(Cremer et al. 2023)](https://doi.org/10.1109/JSTARS.2020.3019333)
](media/image4.png)

In the scope of a use case of the C-Scale Horizon 2020 project we
computed the RQA Trend metric for the whole continent of Europe for the
years 2018 to 2021 (Cremer et al. 2023). During these activities we
reduced the memory usage and thereby the runtime of the algorithm. This
was achieved by improving the algorithm to compute the RQA Trend metric
directly without having to store the underlying recurrence matrix in
memory. These improvements have been possible because the complete data
analysis was implemented in Julia and therefore a change in the
underlying analysis package did not involve changing the programming
language. The data analysis was parallelized using the YAXArrays.jl
package that is developed under the JuliaDataCubes organization. The
analysis code is available under a MIT License to be aligned with
open-science principles. The output of the scientific experiment are in
Zarr data format. An introduction to the method and the software stack
is available at Large-scale EO data handling – [EO College
(eo-college.org)](https://eo-college.org/resource/large-scale-eo-data-handling/)

## Julia Library

The underlying code used in this workflow is developed in the Julia Package RQADeforestation.
The source code is published under MIT license at https://github.com/EarthyScience/RQADeforestation.jl.
TIF files within the selected spatiotemporal extent are loaded into n-dimensional YAXArrays that are the Julia equivalent of xarray in Python.
Data loading is performed lazily, i.e. only data chunks that are actually being requested are loaded into system memory.
This enables processing big datasets even on resource limited computers.
Then, The function `rqatrend` computes the RQA TREND values for the loaded data cube, using the Julia library RecurrenceAnalysis, among others.
Results are written to disk in the Zarr format.
We used [TestItemRunner.jl](https://github.com/julia-vscode/TestItemRunner.jl) to put tests directly next to the function, running tests clearly and in parallel with VSCode.

## OGC Application Package

The Julia library alone does not include executable binaries and tools to upload the results to external object storage systems like MINIO or Amazon S3 for downstream analyzes.
Furthermore, STAC catalog generation must occur somewhere else as well.
A well established way to add those features to the workflow is by putting code and binaries for the individual steps into Docker containers.
We developed docker images and [danlooo/fairsendd_rqa](https://hub.docker.com/r/danlooo/fairsendd_rqa) [danlooo/fairsendd_stage_out](https://hub.docker.com/r/danlooo/fairsendd_stage_out) using continuous integration pipelines that are freely accessible on [dockerhub](https://hub.docker.com).
This allowed us to write the core step of the workflow in Julia for performance reasons and to write the final upload step in Python to have access to its comprehensive package ecosystem.

The workflow execution is handheld using an orchestration tool and configuration files defining the order of the individual steps.
We used [Common Workflow Language (CWL)](https://www.commonwl.org) to describe the entire workflow, creating a Earth Observation Application Package according to OGC Best Practices [(OGC consortium 2021)](https://docs.ogc.org/bp/20-089r1.html#toc0).
Individual steps and the entire workflow can be executed using docker and cwltool, respectively.
In addition, we are developing a connector to start the workflow using OGC API - Processes as well.
This additional abstraction layer allows external users to interact with the workflow using HTTP and allows cloud providers to choose their workflow orchestration tool.

# Implementation status

This report summarizes the current status of the FAIRSenDD project.
Overall, the project is currently on schedule after its first half of the year.
The first two work packages WP1: Selection of operational NoR EO Platform services and WP2: End-to-end FAIR Workflow are finished.
We are currently working on WP3: Code performance enhancement & Cloud platform integration.
Meanwhile, WP5: Project Coordination and Cooperation is running over the entire course of the 1 year project.

![
  Timeline of work packages and milestones.
  No changes have been made to the schedule since the beginning of the project.
  Currently, we are in the 6th month (M6).
](media/image5.png)

## WP1: Selection of operational NoR EO Platform services

Expected: done  
Actual: done

#### Tasks

- Finalise technical requirements of the existing deforestation
  detection software and its planned improvements
- Analyse trade-offs between available platforms
- Identify and select a suitable platform in NoR to run the workflow
- Identify and select an external expert for technical code review
- Prepare a cost estimation
- Submit NoR sponsoring request
- Create a presentation about the trade-off analysis and the selected
  providers

#### Deliverables

- D01: Trade-off analysis presentation for platform selection and code
  review including cost estimation
- D02: NoR sponsoring request document

### Cloud provider selection

The first task of the project was to select a cloud provider that we can use to host the workflow.
In particular, virtual machines were required to test the workflow and to build images using Continuous Integration.
Further details about the selection process are provided in the presentation D01.
Over the course of the first month of the project, we agreed on the following critera to select the cloud provider:

- Must have Sentinel-1 Sigma 0 corrected data hosted within its data center (principle of data locality)
- Should offer renting virtual machines (VMs) with dozens of CPU cores and > 32G RAM per VM
- Total offer must be < 15000€
- Should offer a low price
- Sponsoring should be part of the NoR

After an initial review in the NoR catalog, we continued the review with CloudFerro, Open Telekom Cloud (T Systems), and EODC.
We finally selected EODC as the cloud provider to work with due to the following reasons:

- They offer FAIR Sigma Nought datasets
- Their data access is faster than CDSE due to the optimization of the files towards time series analysis (less tile overlap in Equi7Grid projection)
- They offered the cheapest price in renting VMs (educational discount)
- They have a long history of collaboration with scientists (Technical University of Vienna spin-off)
- We had successful collaborations with them in the past
- they assured to take care of payment processes in future production deployments of the workflow

Finally, we took the offer using a standard NoR sponsorship request.

### Code review expert selection

Next, we selected an external company to review our code and to give suggestions on how to improve its performance.
Most importantly, the code expert must have additional knowledge about data access and Julia, since this is the major programming language of our project.
Due to its low prevalence, it was a big challenge to find such a person, e.g. there was no company in the NoR catalog offering consultancy for Julia.
We further asked APEx and cloudflight with negative outcome.
Finally, we selected Stephan Sahm from [jolin.io](https://www.jolin.io/en/) to review our code.
Up to our knowledge, jolin.io is the only consulting company specialized in Julia.
Its founder Stephan Sahm is maintainer of many Julia packages, including WhereTraits.jl and others.
After initial negotiation, ESA agreed on that collaboration via an ad-hoc NoR sponsorship.
Later on, jolin.io completed a light tier registration at NoR.
We with that there will be more Julia offerings in the NoR portfolio in the future, enabling researchers and software engineers to profit from the computational efficiency offered by this programming language.

## WP2: End-to-end FAIR Workflow

Expected: done

Actual: done

#### Deliverables

- D03: Online documentation for developers and users about the theory, user parameters,
  examples and the underlying code

### 2.1 Set up working environment

#### Tasks

- Identify public repositories to store code, software containers, and custom data and select the best one according to FAIR principles
- Create a custom example dataset with correct annotations to test the deforestation software
- Setup CI/CD infrastructure

#### Status

We opted to publish our code at GitHub, because it is the _de facto_ standard platform to share open source code, making it more likely that the code will be findable and accessible in the future.
The code repository can be accessed at https://github.com/EarthyScience/FAIRSenDD.
The underlying Julia library is also accessible at https://github.com/EarthyScience/RQADeforestation.jl.

Docker container images were uploaded to dockerhub, which is the default repository for public docker images.
This includes image [danlooo/fairsendd_rqa](https://hub.docker.com/r/danlooo/fairsendd_rqa) for analyzing the datasets and the image [danlooo/fairsendd_stage_out](https://hub.docker.com/r/danlooo/fairsendd_stage_out) for uploading the results to S3 compatible object storage.

We built Continuous Integration (CI) pipelines to automatically build and test the code and its corresponding container images and websites for documentation.
Execution is performed on VMs at EODC using GitHub Actions.
We used Terraform and openStack to deploy those VMs in a reproducible way independently of the selected cloud provider.

### 2.2 Make workflow FAIR

#### Tasks

- Export deforestation events as a Zarr Data Cube according to the xcube specification
- Describe output with STAC metadata
- Develop the CWL file and docker images describing the entire workflow using OGC Best Practice
  for Earth Observation Application Package
- Create unit tests for the individual functions and integration tests for the entire workflow
- Ensure data formats comply well with the ones used in the EarthCODE community and FAIR
  principles

#### Status

FAIR principles extend the principles of open source software with interoperability and reusability so that software improvement is not only allowed but also encouraged and simplified.
Therefore, we focused on using well established standards making our code more compatible with other tools.
RQADeforestation.jl uses YAXArrays.jl that uses Zarr format by default.
We ensured that the result data cubes comply with the xcube specification.

We added staging out procedure that uploads the result data with its own STAC catalog as static JSON files as recommended by [OGC Best Practice for Earth Observation Application Package](https://docs.ogc.org/bp/20-089r1.html#toc27).
We developed the CWL workflow and published it in [our repository](https://github.com/EarthyScience/FAIRSenDD/tree/main/ogc-app-cwl).
Docker images [danlooo/fairsendd_rqa](https://hub.docker.com/r/danlooo/fairsendd_rqa) and [danlooo/fairsendd_stage_out](https://hub.docker.com/r/danlooo/fairsendd_stage_out) were automatically created and tested within our CI pipeline.
Overall, this forms an Earth Observation Application Package according to OGC Best Practices, suitable for future publishing in Open Science Catalog of EarthCODE, like the [POLARIS example](https://opensciencedata.esa.int/workflows/polaris-workflow/record).
In addition, we added meta data about code, authors and license according to the FAIR Application Package recommendation [(terradue 2023)](https://terradue.github.io/app-package-training-bids23/).

Testing is a crucial part of software development.
We created unit tests for the individual functions using [TestItemRunner.jl](https://github.com/julia-vscode/TestItemRunner.jl), allowing us to run tests in parallel with a clear integration in VSCode.
In addition, we performed integration tests that runs the main function on the real world test dataset [meggart/RQADeforestationTestData](https://github.com/meggart/RQADeforestationTestData) whenever the code has changed.

### 2.3 Document workflow

#### Tasks

- Create and host FAIR, standardized, and well-structured source code documentation
- Write a user tutorial including an easy-to-read summary of the theory, assumptions, links to published papers, and methods, code on how to execute the example, as well as a description and implications of user-defined parameters enabling parameter tuning

#### Status

We created the website http://fairsendd.eodchosting.eu/ hosting the documentation and APIs.
It serves as a portal to all resources created by this project.
It includes tutorials on how to run the Julia package, the CWL workflow, as well as the scientific background of the underlying algorithm.
The code to generate the documentation website is published under MIT license at the [FAIRSenDD repository](https://github.com/EarthyScience/FAIRSenDD/tree/main/website).
Code examples are executed during documentation building as quarto notebooks ensuring reproducibility of the documentation.
Creating reproducible documentation in multiple programming languages is challenging.
We created an example repository [danlooo/vitepress-quarto-docker](https://github.com/danlooo/vitepress-quarto-docker) to create a website with code examples in Julia, R and Python running in a reproducible code environment that can be used interactively using [Jupyter Binder](https://jupyter.org/binder).
Specific documentation about functions of the underlying Julia package RQADeforestation.jl is published using Documenter at [https://earthyscience.github.io/RQADeforestation.jl/dev](https://earthyscience.github.io/RQADeforestation.jl/dev/).

Please note that the documentation will probably change during the course of WP3: Code performance enhancement & Cloud platform integration.

## WP3: Code performance enhancement & Cloud platform integration

Expected: in progress

Actual: in progress

#### Deliverables

- D04: Code review and optimization report
- D05: Software Specification Document (SRD)
- D06: Software Verification and Validation (V&V) document

### 3.1 Enhance workflow code

#### Tasks

- Perform external code review and refactoring
- Define a list of KPIs to track algorithm performance
- Identify performance bottle-necks
- Evaluate improvement solutions of the workflow
- Enhance the performance of the workflow
- Create software package compliant to OGC “Best Practice for Earth Observation Application
  Package (OGC 20-089)"
- Release the updated workflow using the CI/CD pipeline with persistent identifiers
- Demonstrate software readiness
- Develop a Web GUI prototype to run the workflow

#### Status

The contract between NoR and our external code review expert Stephan Sahm from jolin.io was settled.
He attended our biweekly meetings and contributed 4 commits to the repository RQADeforestation.jl.
Most notably, he drastically reduced the number of memory allocations of the core part of the workflow and created binaries to be used in our docker images using [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl).

The OGC Application Package and CI pipelines for building and testing were developed to a point where the workflow runs without any errors.
Currently, we are working on the last steps of the RQADeforestation.jl workflow, i.e. creating a binary forest change map from the RQA TREND floating point values.

### Benchmark current status

During a progress meeting on 3 Jan 2025, we defined the following KPIs to benchmark our workflow:

- number of implemented algorithms >=2 (e.g. rqatrend, quantile)
- time to first response of a minimum working example <=10s.
  Measures user-friendliness and overhead
- Classification performance on a benchmark dataset (accuracy,
  sensitivity, specificity)
- number of allocations of the rqatrend inner function: required to
  embed in openEO python UDF, helps Julia garbage collector in
  controlling memory usage
- code coverage with unit tests: Do not make a mistake twice in
  further software versions analysis time per computing resources

We added code coverage reports using [codecov.io](https://about.codecov.io/).
Currently, one algorithm, i.e. rqatrend is implemented.
To test the overhead and minimal execution time, we run the main function rqatrend on a single point time series for 10000 samples with 10 evaluations per sample.
To test more realistic execution scenarios, we also run the function on a real world dataset comprising one tile with 15000x15000 pixels and 2 years of Sentinel-1 observations (tile E048N021T3 in the EU from 2021-07-01 to 2023-06-30).

In summary, our code ran 27% faster using 63% less memory with 99.94% less allocations compared to the initial version at the beginning of the project in a real world benchmark scenario.

| indicator                  | v0.1       | v0.2    | improvement |
| -------------------------- | ---------- | ------- | ----------- |
| Duration (tile) [s]        | 884.030    | 649.038 | 27%         |
| Duration (point) [µs]      | 12.774     | 1.137   | 91%         |
| Memory usage (tile) [GiB]  | 606.03     | 223.29  | 63%         |
| Memory usage (point) [KiB] | 3.75       | 0       | 100%        |
| Memory allocations (tile)  | 1498056002 | 887461  | 99.94%      |
| Memory allocations (point) | 8          | 0       | 100%        |
| Code coverage (Unit tests) | 0%         | 47%     | 47%         |

Please note that the code coverage was calculated on the entire codebase that still contains unused code blocks.
As of 21th March 2025, the code coverage improved to 61%.
We are currently in the process to refactor the code and identify lacking tests.
In addition, integration tests covering the entire workflow were already developed.

### 3.2 Explore deployment improvements

#### Tasks

- Explore ways to extend openEO to be able to run user defined functions using Julia or Docker images

#### Status

Unfortunately, there is no Julia backend for openEO yet.
Therefore, we plan to create Python bindings for our Julia library RQADeforestation.jl so that one can use the workflow within a User-Defined Function (UDF) at Python openEO backends.
A major step towards this is to make the Julia function free of additional memory allocations to simplify memory management in a cross language context.
This was archived in version v0.2 of our Julia library.

## WP4: Deployment as on-demand operational service

Expected: Start in the future

Actual: Start in the future

#### Deliverables

- D07: Service Verification & Validation document

#### Tasks

- Negotiate pricing model with the platform provider
- Create the price calculator given user-defined parameters, e.g.
  bounding box and time spans and document the price per unit of area
  and time span
- Deploy the workflow on the host platform linking workflow code,
  metadata and documentation
- Determine corresponding authors and code maintainers to ensure user
  support
- Organise the Service Readiness Review

#### Status

As scheduled, this working package hasn't started yet.

## WP5: Project Coordination and Cooperation

Expected: Ongoing

Actual: Ongoing

#### Deliverables

No deliverables are associated to this work package.

#### Tasks

- Ensure a smooth day-to-day management of the project
- Guarantee the timely submission of deliverables
- Ensure smooth execution of the project, on schedule, and within
  budget
- Organise progress and final meetings
- Communicate the progress of the project to ESA

#### Status

We set up a nextcloud share containing deliverables, presentation slides, reports and Minutes of Meetings form the 4-weekly progress meetings.
In addition, we held 4-weekly internal meetings to discuss technical challenges and to organize the work.
Part of the code review was conducted during those technical meetings.
Individual work was organized in totalling 31 issues and 101 pull requests on GitHub.
Finally, we wrote this mid term report.

# Challenges and Solutions

Here we present any obstacles encountered in this project so far and how we addressed them.

## Making underlying function free of memory allocations

A major bottleneck in analyzing data intensive functions in Julia is the time it takes to allocate memory.
The code will run much faster if one knows at the very beginning how much memory it will use.
It is very difficult in general to predict how much development effort is required to make the code free of additional memory allocations.
In particular, due to the way how satellite images are acquired, there are considerable amount of missing values in the data.
We don't know beforehand how many missing values there will be, making filtering prone to memory allocation.
We managed to do it for the most important part of the code, i.e. the inner function of rqatrend, within the first half of WP3.
Overall, we archived 99.94% less allocations in v0.2 compared to v0.1.

## Complexity in rendering polyglot notebooks

- Interoperability requires to demonstrate the usage of the workflow using various programming languages, e.g. open the result data cube in Python and Julia

- 73% of Jupyter notebooks are not reproducible [(Wang et al. 2023)](https://ieeexplore.ieee.org/document/9270316)
- Documentation frameworks for single language are well established (e.g. Documenter.jl for Julia)
- Well established for R+Python (quarto, reticulate) and .NET ecosystem [(Grot and Hirdes 2024)](https://www.heise.de/en/background/Polyglot-Notebooks-A-practical-introduction-9691634.html)
- Combo Bash+Python+Julia less established
- We failed to precompile RQADeforestation.jl inside quarto knitr engine due to mismatching versions of dependencies
- Management of execution environments is a complex issue
- We build a prototype website able to create reproducible polyglot quarto websites: https://github.com/danlooo/vitepress-quarto-docker
- One just need to add quarto markdown files. GitHub CI will build docker containers, render quarto docuemnts, and deploys the website to GitHub Pages within its CI.
- Code execution environment container can be downloaded from dockerhub
- Repository complies with [Jupyter Binder](https://jupyter.org/binder) enabling interactive Jupyter lab sessions in the exact environment of the repository

## STAC catalogs for Zarr datasets

We added a staging out procedure that uploads the result data with its own STAC catalog as static JSON files as recommended by [OGC Best Practice for Earth Observation Application Package](https://docs.ogc.org/bp/20-089r1.html#toc27).
However, STAC catalogs were designed to solve a problem that exists with GeoTIF but not with Zarr, i.e. having different file structures and ways to declare spatiotemporal dimensions.
A Zarr dataset is more similar to a STAC catalog that it is to an STAC asset or item [(Pangeo 2023)](https://discourse.pangeo.io/t/metadata-duplication-on-stac-zarr-collections/3193).
STAC for Zarr is still useful to provide a unified API for spatiotemporal querying.
Previous efforts have created relevant STAC extensions, e.g. [xarray-assets](https://github.com/stac-extensions/xarray-assets/) and [datacube](https://github.com/stac-extensions/datacube).
We are currently re-evaluating our current STAC implementation for the result data cubes if those extensions are implemented correctly.
In addition, one needs to re-project the tile bounding box from Equi7Grid projection back to WGS84 as required by the GeoJSON standard.
We added code in the stage out step of the workflow considering all 7 possible projections (one per continent, EPSG:27701 to EPSG:27707) using the STAC extension [projection](https://github.com/stac-extensions/projection).

# Financial Report

| Item                                   | Beneficiary                             |        Cost |
| -------------------------------------- | --------------------------------------- | ----------: |
| Contractor budget                      | Max Planck Institute of Biogeochemistry | € 149996.00 |
| NoR sponsoring for computing resources | EODC                                    |  € 15360.97 |
| ad-hoc NoR sponsoring for code review  | jolin.io                                |  € 15000.00 |

At the beginning of this project, we asked for a total budget of € 149996.00 in our proposal.
This number was also settled in the contract.
The first payment of € 70000 will be due after the mid-term review if Deliverables D1, D2, and this mid-term report are accepted by ESA.
The remaining €79,996 will be due after the entire project finished successfully.
As part of WP1, we did an additional NoR sponsoring for renting computing resources at EODC totalling € 15360.97.

Further information is provided at the ESA contract 4000144670/24/I-EB and the NoR sponsorship documents of D02.Lastly, we got an ad-hoc sponsorship from jolin.io to perform code review totalling up to € 15000.00 with 150€ excl. VAT payed per hour worked.
Further information is provided at the ESA contract 4000144670/24/I-EB and the NoR sponsorship documents of D02.

# Outlook

- Finish WP3 code performance enhancement
- Do WP4 Deployment
- Submitted talk to Living Planet Symposium 2025

# Conclusion

- Recap of the progress and its significance.
- Reaffirmation of the project's alignment with the agency's goals.
