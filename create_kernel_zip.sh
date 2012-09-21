#!/bin/bash

COMMAND="$1"
ADDITIONAL="$2"
TOP=${PWD}
CURRENT_DIR=`dirname $0`

# create kernel zip after successfull build
create_kernel_zip()
{
    if [ -e out/target/product/${COMMAND}/boot.img ]; then
        if [ -e ${TOP}/buildscripts/samsung/${COMMAND}/kernel_updater-script ]; then

            echo -e "${txtylw}Package KERNELUPDATE:${txtrst} out/target/product/${COMMAND}/kernel-aokp-$(date +%Y%m%d)-${COMMAND}-signed.zip"
            cd out/target/product/${COMMAND}

            rm -rf kernel_zip
            rm kernel-akop-*

            mkdir -p kernel_zip/system/lib/modules
            mkdir -p kernel_zip/META-INF/com/google/android

            echo "Copying boot.img..."
            cp boot.img kernel_zip/
            echo "Copying kernel modules..."
            cp -R system/lib/modules/* kernel_zip/system/lib/modules
            echo "Copying update-binary..."
            cp obj/EXECUTABLES/updater_intermediates/updater kernel_zip/META-INF/com/google/android/update-binary
            echo "Copying updater-script..."
            cat ${TOP}/buildscripts/samsung/${COMMAND}/kernel_updater-script > kernel_zip/META-INF/com/google/android/updater-script
                
            echo "Zipping package..."
            cd kernel_zip
            zip -qr ../kernel-aokp-$(date +%Y%m%d)-${COMMAND}.zip ./
            cd ${TOP}/out/target/product/${COMMAND}

            echo "Signing package..."
            java -jar ${TOP}/out/host/linux-x86/framework/signapk.jar ${TOP}/build/target/product/security/testkey.x509.pem ${TOP}/build/target/product/security/testkey.pk8 kernel-aokp-$(date +%Y%m%d)-${COMMAND}.zip kernel-aokp-$(date +%Y%m%d)-${COMMAND}-signed.zip
            rm kernel-aokp-$(date +%Y%m%d)-${COMMAND}.zip
            echo -e "${txtgrn}Package complete:${txtrst} out/target/product/${COMMAND}/kernel-aokp-$(date +%Y%m%d)-${COMMAND}-signed.zip"
            md5sum kernel-aokp-$(date +%Y%m%d)-${COMMAND}-signed.zip
            cd ${TOP}
        else
            echo -e "${txtred}No instructions to create out/target/product/${COMMAND}/kernel-aokp-$(date +%Y%m%d)-${COMMAND}-signed.zip... skipping."
            echo -e "\r\n ${txtrst}"
        fi
    fi
}

        create_kernel_zip


