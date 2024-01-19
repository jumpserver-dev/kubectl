#!/bin/bash
#

set -ex

version=$1

if [ -z "$version" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

BASE_DIR=$(cd "$(dirname "$0")" || exit 1; pwd)

for arch in 386 amd64 arm arm64 ppc64le s390x; do
    cd ${BASE_DIR} || exit 1
    app_name=kubectl
    build_dir=build
    archive_name=${app_name}-${version}-linux-${arch}
    working_dir=${build_dir}/${archive_name}
    mkdir -p ${working_dir}
    wget -O ${working_dir}/${app_name} https://cdn.dl.k8s.io/release/${version}/bin/linux/${arch}/${app_name}
    cd ${build_dir} || exit 1
    tar -zcvf ${archive_name}.tar.gz ${archive_name}
done

cd ${BASE_DIR}/${build_dir} || exit 1
sha256sum *.tar.gz > checksums.txt