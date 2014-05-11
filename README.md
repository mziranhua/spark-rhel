spark-rhel
==========

Simple script to build and generate an, RHEL, RPM for apache spark- http://spark.apache.org.  

The spark build requires the JDK - this script was tested using version 1.7.0_55.

The function that builds the RPM uses fpm - https://github.com/jordansissel/fpm. fpm is a ruby tool, so you will ruby and rubygems.
