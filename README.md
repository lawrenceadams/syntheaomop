# Synthea OMOP

Make it easy to generate OMOP data with synthea.

## Instructions

```sh
# Setup env file
cp env.list.example env.list
docker build --build-arg NUMBER_PATIENTS=1000 -t syntheagen
# Note: may want to connect to the current network
docker run --env-file env.list syntheagen
```