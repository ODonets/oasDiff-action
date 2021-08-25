
#assign descriptiv variables to the values of arguments
PATH=$1
OAS_FILE_OLD=$2
OAS_FILE_NEW=$3
CHANGE_LOG_FILE=${PATH}/$4

# compare two files (old and new) and catch the output and write the result into the file
set +e
docker run --rm -t -v $(pwd)/oas:/data openapitools/openapi-diff:latest /data/$OAS_FILE_OLD /data/$OAS_FILE_NEW --fail-on-incompatible
exit_code=$?
set -e
if [[ $exit_code == 0 ]]; then
  echo "Comparison of two OASs files was successfull"
elif [[ $exit_code == 1 ]]; then
  echo "::warning:: The new OAS version is not compatible with the previous one."
  exit 1
else
  echo "::error::Execution of the comparison failed, comparision script exit_code is $exit_code"
  exit 2
fi