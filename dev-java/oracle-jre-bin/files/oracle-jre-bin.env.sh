# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

VERSION="Oracle JRE ${PV}"
JAVA_HOME="${EPREFIX}/opt/${P}"
JDK_HOME="${EPREFIX}/opt/${P}"
JAVAC="\${JAVA_HOME}/bin/javac"
PATH="\${JAVA_HOME}/bin:\${JAVA_HOME}/bin"
ROOTPATH="\${JAVA_HOME}/bin:\${JAVA_HOME}/bin"
LDPATH="\${JAVA_HOME}/lib/$(get_system_arch)/:\${JAVA_HOME}/lib/$(get_system_arch)/server/"
MANPATH="${EPREFIX}/opt/${P}/man"
PROVIDES_TYPE="JRE"
PROVIDES_VERSION="${SLOT}"
BOOTCLASSPATH="\${JAVA_HOME}/lib/resources.jar:\${JAVA_HOME}/lib/rt.jar:\${JAVA_HOME}/lib/sunrsasign.jar:\${JAVA_HOME}/lib/jsse.jar:\${JAVA_HOME}/lib/jce.jar:\${JAVA_HOME}/lib/charsets.jar:\${JAVA_HOME}/classes"
GENERATION="2"
ENV_VARS="JAVA_HOME JDK_HOME JAVAC PATH ROOTPATH LDPATH MANPATH"
