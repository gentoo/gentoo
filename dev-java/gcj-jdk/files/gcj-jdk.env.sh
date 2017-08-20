# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

VERSION="GCJ ${PV}"
JAVA_HOME="${EPREFIX}/usr/$(get_libdir)/${P}"
JDK_HOME="${EPREFIX}/usr/$(get_libdir)/${P}"
JAVAC="\${JAVA_HOME}/bin/javac"
PATH="\${JAVA_HOME}/bin"
ROOTPATH="\${JAVA_HOME}/bin"
LDPATH="\${JAVA_HOME}/lib"
INFOPATH="\${JAVA_HOME}/info"
MANPATH="\${JAVA_HOME}/man"
PROVIDES_TYPE="JDK JRE"
PROVIDES_VERSION="1.5"
BOOTCLASSPATH="\${JAVA_HOME}/jre/lib/rt.jar"
GENERATION="2"
ENV_VARS="JAVA_HOME JDK_HOME JAVAC PATH ROOTPATH LDPATH INFOPATH MANPATH"
