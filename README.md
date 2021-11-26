# Containerized API-Testing using Newman 

This project can be used to build a docker container that can execute postman API-Test cases to environment with in reachable network.

## Overview
Upon the running the container with the required parameters, the solution will identify the test and environment file from the attached volume and execute the test cases using Newman cli.
Post execution an html and xml report will get generated based on the execution statistics.

## What is API-Testing ?

**API-Testing** is a type of software testing where application programming interfaces (APIs) are tested to determine if they meet expectations for functionality, reliability, performance, and security.
It is intended to reveal bugs, inconsistencies or deviations from the expected behavior of an API. Commonly, applications have three separate layers:
- Presentation Layer or user interface
- Business Layer or application user interface for business logic processing
- Database Layer for modeling and manipulating data

## What is Postman and Newman?

**Postman** is an application used for API testing. Postman sends an API request to the web server and receives the response, whatever it is. Postman comes with an extensive user interface supported for all the test needs of an API.

**Newman** is a CLI tool that is used  to executes collections created using postman as part of the API Testing process. It is a simple small cli without any bulky user interface and can be integrated smoothly with CI-CD and DevOps lifecycle tools.

## How this is Implemented?

A docker image based on node, which consist of the **Newman cli** and a shell script **entrypoint.sh**. Upon of running the container the shell script looks for the environment and test script files and executes the Newman command for API testing. The command also generated an **.xml** and **.html** report based on the execution data.
```sh
newman run \
        --verbose \
        --disable-unicode \
        --reporters cli,junit,html \
        --reporter-junit-export ${report_file}.xml \
        --reporter-html-export "${report_file}.html"  \
        -e ${env_file} ${test_file} \
        --insecure
```
**Note:**\
The newman test can be executed without an environment configuration file.

## What are the Requirements?

1. Volume with the required test script and environment files need to be mounted to **/etc/newman** path of the container.
2. File need to follow the below mentioned naming convenction inorder to be read automatically.
    * Test Script : ``` *postman.collection.json``` \
        Example : ``` demoAPI.postman.collection.json``` 
    * Environment Configuration File (Optional) : ``` *.postman.environment.json``` \
        Example : ``` demoAPI.postman.environment.json```
3. Sample Test Script:
```json
{
	"name": "GET Employee",
	"event": [
		{
			"listen": "test",
			"script": {
				"exec": [
					"pm.test(\"Status code is 200\", function () {",
					"    ",
					"    pm.response.to.have.status(200);",
					"    ",
					"});",
					"",
				],
				"type": "text/javascript"
			}
		}
}
```
**Reference:** [Learn how to write postman API Test scripts](https://learning.postman.com/docs/writing-scripts/script-references/test-examples/) 

4. Sample Environment Configuration File:
```json
{
	"id": "a35fb00c-e686-4294-bad7-6a847f9aab5b",
	"name": "Demo-ENV",
	"values": [
		{
			"key": "session-id",
			"value": "758c145f-b3ac-47f3-807c-f263d67c4e28",
			"enabled": true
		}
    ]
    	"_postman_variable_scope": "environment",
	"_postman_exported_at": "2021-08-23T13:54:54.716Z",
	"_postman_exported_using": "Postman/7.36.5"
}
```
**Reference:** [How to add and export environment variable -Postman](https://learning.postman.com/docs/sending-requests/managing-environments/)

## How to get this Working?

1. Clone this git repository into the computer
```sh
git clone <url>
```
2.  Run the standard docker build command to create a image of the Dockerfile
```sh
docker build -t <imagename:tag> <build path>
```
Example: ``` docker build -t newman_demo:1.0 . ```

3. Run API-Testing by running the container using the build image.
**Senerio-1** with no variables
```sh 
docker run -it -v <Script and Env location>:/etc/newman <imagename:tag>
```
Example: ``` docker run -it -v /home/user/test/:/etc/newman newman_demo:1.0 ```

**Senerio-2** with Script, Environment and report file name.
```sh 
docker run -it -v <Script and Env location>:/etc/newman -e TEST_FILE=<test_file name> -e ENV_FILE=<env file name> -e REPORT_FILE=<report_name> <imagename:tag>
```
Example: 
``` docker run -it -v /home/user/test/:/etc/newman -e TEST_FILE=demoAPI.postman.collection.json -e  ENV_FILE=demoAPI.postman.environment.json -e REPORT_FILE=example_report newman_demo:1.0```

## Environment Variables

The Variables Usage as below:
```python
$TEST_FILE=<NAME OF TEST FILE>
$ENV_FILE=<NAME OF ENV FILE>
$REPORT_FILE=<NAME OF EXPECTED REPORT FILE> default (Newman_Test-$date)
```


