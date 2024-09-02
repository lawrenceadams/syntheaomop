FROM eclipse-temurin:20-jdk AS synthea

RUN curl -L -O https://github.com/synthetichealth/synthea/releases/download/v3.2.0/synthea-with-dependencies.jar

ARG NUMBER_PATIENTS=200

# This emits to `/output`
RUN java -jar synthea-with-dependencies.jar -p $NUMBER_PATIENTS --exporter.fhir.export=false --exporter.csv.export=true

FROM r-base AS rbase 

COPY --from=synthea /output /output 

RUN apt-get update && \
    apt-get install -y r-cran-devtools default-jdk libtirpc-dev

RUN Rscript -e "devtools::install_github('OHDSI/ETL-Synthea')"

COPY run.sh /app/run.sh
COPY load_synthea.r /app/load_synthea.r

CMD /app/run.sh 
