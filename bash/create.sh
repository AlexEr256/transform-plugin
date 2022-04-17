#!/bin/bash

curl -i -X POST http://localhost:8001/services --data name=example_service --data url='http://mockbin.org' ;
curl -i -X POST http://localhost:8001/services/example_service/routes --data 'paths[]=/mock' --data name=mocking ;
