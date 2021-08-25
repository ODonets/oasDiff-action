#assign descriptiv variables to the values of arguments
WORKING_DIR=$1
OAS_FILE_OLD=$2
OAS_FILE_NEW=$3
CHANGE_LOG_FILE=${WORKING_DIR}/$4

# compare two files (old and new) and catch the output and write the result into the file 
set +e
echo "CHANGE_LOG_FILE = $CHANGE_LOG_FILE"
output=$(docker run --rm -t -v $(pwd)/oas:/data openapitools/openapi-diff:latest /data/$OAS_FILE_OLD /data/$OAS_FILE_NEW --fail-on-incompatible)
exit_code=$?
set -e
if [[ $exit_code == 0 ]]; then
  echo "success"
  echo "$output" > "$CHANGE_LOG_FILE"
  exit 0
elif [[ $exit_code == 1 ]]; then
  echo "::warning::not compatible"
  echo "$output" > "$CHANGE_LOG_FILE"
  exit 0
else
  echo "::error::execution failed, exit_code=$exit_code"
  exit 2
fi