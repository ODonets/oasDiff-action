
#assign descriptiv variables to the values of arguments
INPUT_FILE_OLD=$1
INPUT_FILE_NEW=$2

# compare two files (old and new) and catch the output and write the result into the file 
set +e
docker run --rm -t -v $(pwd)/oas:/data openapitools/openapi-diff:latest /data/$INPUT_FILE_OLD /data/$INPUT_FILE_NEW --fail-on-incompatible 
exit_code=$?
set -e
if [[ $exit_code == 0 ]]; then
  echo "success"
elif [[ $exit_code == 1 ]]; then
  echo "::warning::not compatible"
  exit 1
else
  echo "::error::execution failed, exit_code=$exit_code"
  exit 2
fi