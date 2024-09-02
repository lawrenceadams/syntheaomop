 devtools::install_github("OHDSI/ETL-Synthea")

 library(ETLSyntheaBuilder)
 # We are loading a version 5.4 CDM into a local PostgreSQL database called "synthea10".
 # The ETLSyntheaBuilder package leverages the OHDSI/CommonDataModel package for CDM creation.
 # Valid CDM versions are determined by executing CommonDataModel::listSupportedVersions().
 # The strings representing supported CDM versions are currently "5.3" and "5.4". 
 # The Synthea version we use in this example is 2.7.0.
 # However, at this time we also support 3.0.0, 3.1.0 and 3.2.0.
 # Please note that Synthea's MASTER branch is always active and this package will be updated to support
 # future versions as possible.
 # The schema to load the Synthea tables is called "native".
 # The schema to load the Vocabulary and CDM tables is "cdm_synthea10".  
 # The username and pw are "postgres" and "lollipop".
 # The Synthea and Vocabulary CSV files are located in /tmp/synthea/output/csv and /tmp/Vocabulary_20181119, respectively.
 
 # For those interested in seeing the CDM changes from 5.3 to 5.4, please see: http://ohdsi.github.io/CommonDataModel/cdm54Changes.html
 

DatabaseConnector::downloadJdbcDrivers(
  'postgresql',
  pathToDriver = '/drivers',
  method = "auto"
 )

cd <- DatabaseConnector::createConnectionDetails(
  dbms     = "postgresql", 
  server   = Sys.getenv('TARGET_DATABASE'),    # with form host/database  
  user     = Sys.getenv('PGUSER'), 
  password = Sys.getenv('PGPASSWORD'), 
  port     = Sys.getenv('PGPORT'),
  pathToDriver = "/drivers"  
)

cdmSchema      <- Sys.getenv('CDM_SCHEMA')
cdmVersion     <- "5.4"
syntheaVersion <- "3.2.0"
syntheaSchema  <- Sys.getenv('SYNTHEA_SCHEMA')
syntheaFileLoc <- "/output/csv"
vocabFileLoc   <- "/tmp/vocab"

ETLSyntheaBuilder::CreateCDMTables(connectionDetails = cd, cdmSchema = cdmSchema, cdmVersion = cdmVersion)
ETLSyntheaBuilder::CreateSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
ETLSyntheaBuilder::LoadSyntheaTables(connectionDetails = cd, syntheaSchema = syntheaSchema, syntheaFileLoc = syntheaFileLoc)
ETLSyntheaBuilder::LoadVocabFromCsv(connectionDetails = cd, cdmSchema = cdmSchema, vocabFileLoc = vocabFileLoc)

ETLSyntheaBuilder::CreateMapAndRollupTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)

## Optional Step to create extra indices
ETLSyntheaBuilder::CreateExtraIndices(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, syntheaVersion = syntheaVersion)
ETLSyntheaBuilder::LoadEventTables(connectionDetails = cd, cdmSchema = cdmSchema, syntheaSchema = syntheaSchema, cdmVersion = cdmVersion, syntheaVersion = syntheaVersion)
