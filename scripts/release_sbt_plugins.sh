#!/bin/sh

cd `dirname $0`/..

sbt "g sbt012" 
sbt "project mapper-generator" ++2.9.2 publish 

sbt "g sbt013" 
sbt "project mapper-generator" ++2.10.2 publish 

sbt "g sbt013"