#!/bin/bash
echo "Start building VPL ami instance"
if packer build -machine-readable ./packer/vpl.json > out.txt
 then 
ARTIFACT=$( cat out.txt |awk -F, '$0 ~/artifact,0,id/ {print $6}' )
 else 
  echo "Packer can't compile ami for VPL" && exit 1
fi

AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo "Saving vpl ami id to variables.tf"
echo 'variable "vpl_ami_id" { default = "'${AMI_ID}'" }' >> ./project/variables.tf

echo "Start building Moodle ami instance"
if packer build -machine-readable ./packer/moodle_arm.json > outmod.txt
  then
    ARTIFACT_MOODLE=$( cat outmod.txt |awk -F, '$0 ~/artifact,0,id/ {print $6}' )
  else
    echo "Packer can't compile ami for Moodle" && exit 1
fi

AMI_MOODLE_ID=`echo $ARTIFACT_MOODLE | cut -d ':' -f2`
echo "Saving moodle ami id  to variables.tf"
echo 'variable "moodle_ami_id" { default = "'${AMI_MOODLE_ID}'"  s}' >> ./project/variables.tf

#echo "Prepearing AWS environment by terraform"
#cd ./prerequisites
#terraform init
#terraform apply -auto-approve

echo "Starting deploying AWS environment by terraform"
cd ./project
terraform init 
terraform apply -auto-approve
