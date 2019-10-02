#!/bin/bash -e

get_sources() {
  mkdir lineage
  cd lineage

  repo init -u https://github.com/LineageOS/android.git -b cm-14.1 --depth 1
  git clone https://github.com/lineageos-dev/android_local_manifests.git --single-branch -b cm-14.1 .repo/local_manifests
  repo sync -c --no-tags --no-clone-bundle -j8 -q

  cd ..
}

replace_signing_keys() {
  cd lineage

  for key in media platform shared testkey
  do
    curl -sSL -o build/target/product/security/${key}.pk8 https://github.com/lineageos-dev/signing-keys/raw/master/${key}.pk8
    curl -sSL -o build/target/product/security/${key}.x509.pem https://github.com/lineageos-dev/signing-keys/raw/master/${key}.x509.pem
  done

  cd ..
}

build_firmware() {
  cd lineage

  source build/envsetup.sh
  lunch lineage_hammerhead-userdebug
  #mka bacon
  #make -j16 bacon

  cd ..
}

get_sources
replace_signing_keys
build_firmware
