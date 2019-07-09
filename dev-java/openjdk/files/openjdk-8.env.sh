# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

VERSION="OpenJDK ${PV}"
JAVA_HOME="${EPREFIX}/usr/$(get_libdir)/${PN}-${SLOT}"
JDK_HOME="${EPREFIX}/usr/$(get_libdir)/${PN}-${SLOT}"
JAVAC="\${JAVA_HOME}/bin/javac"
PATH="\${JAVA_HOME}/bin"
ROOTPATH="\${JAVA_HOME}/bin"
LDPATH="\${JAVA_HOME}/lib/:\${JAVA_HOME}/lib/server/"
MANPATH="\${JAVA_HOME}/man"
PROVIDES_TYPE="JDK JRE"
PROVIDES_VERSION="1.${SLOT}"
BOOTCLASSPATH="\${JAVA_HOME}/jre/lib/resources.jar:\${JAVA_HOME}/jre/lib/rt.jar:\${JAVA_HOME}/jre/lib/jsse.jar:\${JAVA_HOME}/jre/lib/jce.jar:\${JAVA_HOME}/jre/lib/charsets.jar:\${JAVA_HOME}/jre/lib/jfr.jar"
GENERATION="2"
ENV_VARS="JAVA_HOME JDK_HOME JAVAC PATH ROOTPATH LDPATH MANPATH"
