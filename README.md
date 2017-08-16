# SDC Microservice Versions and Releases
This repository tracks which versions of the Survey Data Collection (SDC) platform microservices are deployed to which environment, loosely following the approach detailed in [_Versioning a Microservice System with git_](https://opencredo.com/versioning-a-microservice-system-with-git/). It also tracks releases and release notes.

## Cloud Foundry Spaces
This repository contains Git branches corresponding to the Cloud Foundry spaces (environments) below:

| Branch/Space                                                               | Purpose                     |
| :------------------------------------------------------------------------- | :-------------------------- |
| [cat](https://github.com/ONSdigital/sdc-service-versions/tree/cat)         | Customer Acceptance Testing |
| [ci](https://github.com/ONSdigital/sdc-service-versions/tree/ci)           | Continuous Integration      |
| [demo](https://github.com/ONSdigital/sdc-service-versions/tree/demo)       | Demonstations               |
| [dev](https://github.com/ONSdigital/sdc-service-versions/tree/dev)         | Development                 |
| [int](https://github.com/ONSdigital/sdc-service-versions/tree/int)         | Integration                 |
| [preprod](https://github.com/ONSdigital/sdc-service-versions/tree/preprod) | Pre-Production              |
| [prod](https://github.com/ONSdigital/sdc-service-versions/tree/prod)       | Production                  |
| [sit](https://github.com/ONSdigital/sdc-service-versions/tree/sit)         | System Integration Testing  |
| [test](https://github.com/ONSdigital/sdc-service-versions/tree/test)       | Functional Testing          |

The **services** directory within each branch contains a text file per deployed microservice that contains the version number of the microservice deployed within that space.

The **releases** directory within every branch contains a CSV file that contains the version number of each microservice comprising a release.

The **release-notes** directory within every branch contains an aggregated release note for every release.

## Copyright
Copyright (C) 2017 Crown Copyright (Office for National Statistics)
