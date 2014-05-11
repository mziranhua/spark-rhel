#!/bin/bash

# Setup to do everything under /home/spark. Can change all that of course, by modifying the variables below. 

# The spark build requires the JDK - this script was tested using version 1.7.0_55.

# The function that builds the RPM uses fpm - https://github.com/jordansissel/fpm.
# fpm is a ruby tool, so you will ruby and rubygems.

WGET=/usr/bin/wget
MKDIR=/bin/mkdir 
TAR=/bin/tar
FPM=/usr/bin/fpm
SOURCE_URL="http://d3kbcqa49mib13.cloudfront.net/spark-0.9.1.tgz"
HOME=/home/spark
SOURCE_DIR=$HOME/source
SPARK_SOURCE_DIR=$HOME/spark_source
SPARK_VERSION=0.9.1
SPARK_TGZ=$SOURCE_DIR/spark-$SPARK_VERSION.tgz
SPARK_SOURCE_DIR=$SOURCE_DIR/spark-$SPARK_VERSION
SPARK_HADOOP_VERSION=2.0.0-cdh4.6.0

function download_source() {
    $MKDIR -p $SOURCE_DIR
    $WGET -P $SOURCE_DIR $SOURCE_URL &> /dev/null
    
    if [ ! "$?" -eq 0 ] || [ ! -f $SPARK_TGZ ]; then
	echo "Could not download source"
	exit 1
    else
	echo "Source downloaded to: $SPARK_TGZ"
    fi
}

function uncompress_source() {
    $TAR -C $SOURCE_DIR -xzvf $SPARK_TGZ &> /dev/null
    
    if [ ! "$?" -eq 0 ] || [ ! -d $SPARK_SOURCE_DIR ]; then
	echo "Could not uncompress source"
	exit 1
    else
	echo "Source uncompressed under: $SPARK_SOURCE_DIR"
    fi
} 


function build_spark(){
    old_pwd="$PWD"
    cd $SPARK_SOURCE_DIR
    ./make-distribution.sh --hadoop "$SPARK_HADOOP_VERSION"
    cd $old_pwd
}

function build_spark_rpm(){
    old_pwd="$PWD"
    cd $SPARK_SOURCE_DIR
    mv dist spark
    $FPM -s dir -t rpm -n "miguel-spark" -v "$SPARK_VERSION" -a "all" --directories=/usr/local/share/spark --prefix "/usr/local/share" --url "http://spark.incubator.apache.org" --maintainer "mziranhua" --description "An open source cluster computing system that aims to make data analytics fast" --license "Apache Software Foundation (ASF)" --vendor "Apache Software Foundation (ASF)" --category "grid-thirdparty" --rpm-user spark --rpm-group spark --epoch 1 --verbose spark 
}

function main() {
    if [ ! -f $SPARK_TGZ ]; then
	download_source
    fi
    
    if [ ! -d $SPARK_SOURCE_DIR ]; then
	uncompress_source
    fi
    
    build_spark
    build_spark_rpm
}

main