start_dir=$(pwd)
cd /Users/qazal/code/tinygrad/tinygrad
git ls-files | tar -czf $start_dir/tinygrad.tar.gz -T -
cd $start_dir
docker build -t tinygrad_cuda .
rm tinygrad.tar.gz
