#!/bin/bash
echo "Start building VPL ami instance"
if packer build -machine-readable ./packer/vpl.json > out.txt
 then 
     echo "VPL AMI instance is created"
 else 
  echo "Packer can't compile ami for VPL" && exit 1
fi

echo "Start building Moodle ami instance"
if packer build -machine-readable ./packer/moodle_arm.json > outmod.txt
  then
      echo "Moodle AMI inctance is created"
  else
    echo "Packer can't compile ami for Moodle" && exit 1
fi

#echo "Prepearing AWS environment by terraform"
#cd ./prerequisites
#terraform init
#terraform apply -auto-approve

echo "Starting deploying AWS environment by terraform"
cd ./project
terraform init 
terraform apply -auto-approve
