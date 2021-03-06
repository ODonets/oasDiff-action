#assign descriptiv variables to the values of arguments
WORKING_DIR=$1
OAS_FILE_OLD=$2
OAS_FILE_NEW=$3
CHANGE_LOG_DIR=${WORKING_DIR}/$4

# compare two files (old and new) and catch the output and write the result into the file 
set +e
echo "CHANGE_LOG_DIR = $CHANGE_LOG_DIR"
output=$(docker run --rm -t -v $(pwd)/${WORKING_DIR}:/data openapitools/openapi-diff:latest /data/$OAS_FILE_OLD /data/$OAS_FILE_NEW --fail-on-incompatible)
exit_code=$?
set -e
if [[ $exit_code == 0 ]]; then
  echo "Comparison of two OASs files was successfull"
  echo "$output" > "$CHANGE_LOG_DIR"
  echo "Exit code of the file writing command is $?"
  exit $?
elif [[ $exit_code == 1 ]]; then
  echo "::warning:: The new OAS version is not compatible with the previous one."
  echo "$output" > "$CHANGE_LOG_DIR"
  echo "Exit code of the file writing command is  $?"
  exit 1
else
  echo "::error::execution failed, exit_code=$exit_code"
  exit $exit_code
fi