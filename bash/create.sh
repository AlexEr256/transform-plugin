#!/bin/bash

curl -i -X POST http://localhost:8001/services --data name=example_service --data url='https://reqres.in/api/users?page=2' ;
curl -i -X POST http://localhost:8001/services/example_service/routes --data 'paths[]=/' --data name=mocking ;
