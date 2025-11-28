#/bin/bash

BINARY_FILE=cmakeTest
workdir=/usr/local/${BINARY_FILE} # 程序目录
noarch_dir=${workdir}/noarch

rpm_post_install(){
  echo "RPM_POST_INSTALL start..."
  tar xzvf ${workdir}/noarch_bin.tar.gz -C ${workdir}/
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