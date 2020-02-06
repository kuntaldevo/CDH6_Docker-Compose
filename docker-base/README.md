## Docker Base
This image is the base image and used to build other hadoop/spark images.
This image is based on CentOS 7 and contains following:
* Java 8 update 144 (Oracle JDK 64 bit)
* Kerberos client
* gosu
* Other utilities like tar, wget, etc.