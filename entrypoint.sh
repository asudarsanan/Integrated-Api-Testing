#!/bin/sh
#read vars from runtime variables
env_file=${ENV_FILE}
test_file=${TEST_FILE}
report_file=${REPORT_FILE}
#define vars from docker volume
if [ -z $test_file ];then
    #read test script file based on extention
    file_test=$(ls  *postman_collection.json | sort -V | tail -n1)
    if [ -f "$file_test" ]; then
        test_file=$file_test
    else 
        # stop execution since, no test script found
        echo "No Test Script Files found in Workspace"
        echo "Error: Specify the Test file as TEST_FILE variable or keep test file under docker volume with extention .postman_collection.json"
        echo "Testing Failed"
        exit 1;
    fi
fi
if [ -z $env_file ]; then
    #read test script file based on extention
    file_env=$(ls  *postman_environment.json| sort -V | tail -n1)
    if [ -f "$file_env" ]; then
        env_file=$file_env
    else 
        echo " No Environment Files found in Workspace"
        echo " Running API- Testing without Environment configuration"
    fi
fi
if [ -z $report_file ]; then 
    now=`date +"%Y-%m-%d"`
    report_file="Newman_Test-$now"
fi
newman -v
#run newman command without environment paramter
if [ -z $env_file ]; then
    echo " Starting API Testing ... "
    echo "Test Script is $test_file"
    echo "Report File is $report_file"
    newman run \
        --verbose \
        --disable-unicode \
        --reporters cli,junit,html \
        --reporter-junit-export ${report_file}.xml \
        --reporter-html-export "${report_file}.html"  \
        ${test_file} \
        --insecure
else 
    #run newman with environment parameters
    echo "Initating API Testing ..."
    echo "Test Script is $test_file"
    echo "Environment file is $env_file"
    echo "Report File is $report_file"
    newman run \
        --verbose \
        --disable-unicode \
        --reporters cli,junit,html \
        --reporter-junit-export ${report_file}.xml \
        --reporter-html-export "${report_file}.html"  \
        -e ${env_file} ${test_file} \
        --insecure
fi

    