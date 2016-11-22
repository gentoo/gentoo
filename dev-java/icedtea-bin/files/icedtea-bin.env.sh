# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

VERSION="IcedTea JDK ${PV}$(multilib_is_native_abi || printf ' ('${ABI}')')"
JAVA_HOME="${EPREFIX}/opt/icedtea-bin-${PV}$(multilib_is_native_abi || printf -- -${ABI})"
JDK_HOME="${EPREFIX}/opt/icedtea-bin-${PV}$(multilib_is_native_abi || printf -- -${ABI})"
JAVAC="\${JAVA_HOME}/bin/javac"
PATH="\${JAVA_HOME}/bin:\${JAVA_HOME}/jre/bin"
ROOTPATH="\${JAVA_HOME}/bin:\${JAVA_HOME}/jre/bin"
LDPATH="\${JAVA_HOME}/jre/lib/$(get_system_arch)/:\${JAVA_HOME}/jre/lib/$(get_system_arch)/server/$([[ ${SLOT} = 7 ]] && printf :\${JAVA_HOME}/jre/lib/$(get_system_arch)/xawt/)"
MANPATH="${EPREFIX}/opt/icedtea-bin-${PV}/man"
PROVIDES_TYPE="JDK JRE"
PROVIDES_VERSION="1.${SLOT}"
# Taken from sun.boot.class.path property
BOOTCLASSPATH="\${JAVA_HOME}/jre/lib/resources.jar:\${JAVA_HOME}/jre/lib/rt.jar:\${JAVA_HOME}/jre/lib/sunrsasign.jar:\${JAVA_HOME}/jre/lib/jsse.jar:\${JAVA_HOME}/jre/lib/jce.jar:\${JAVA_HOME}/jre/lib/charsets.jar:\${JAVA_HOME}/jre/lib/jfr.jar"
GENERATION="2"
ENV_VARS="JAVA_HOME JDK_HOME JAVAC PATH ROOTPATH LDPATH MANPATH"
