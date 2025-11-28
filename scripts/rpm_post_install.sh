#/bin/bash

BINARY_FILE=cmakeTest
workdir=/usr/local/${BINARY_FILE} # 程序目录
noarch_dir=${workdir}/noarch

rpm_post_install(){
  tar xzvf ${noarch_dir}/noarch_bin.tar.gz -C ${noarch_dir}/
  hw_arch=$(uname -m)
  bin_source=${noarch_dir}/${BINARY_FILE}-${hw_arch}
  bin_target=/usr/local/bin/${BINARY_FILE}
  if [ -f  "${bin_source}" ];then
      cp -f ${bin_source} ${bin_target}
      chmod +x ${bin_target}
  else
      echo "Not support OS arch: ${hw_arch}!"
      exit 1
  fi
}
rpm_post_install