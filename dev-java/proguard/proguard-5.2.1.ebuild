# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Free Java class file shrinker, optimizer, and obfuscator"
HOMEPAGE="http://proguard.sourceforge.net/"
MY_P=${P/-/}
MY_P=${MY_P/_/}
SRC_URI="mirror://sourceforge/proguard/${MY_P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="ant examples"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5
	>=dev-java/ant-core-1.7:0"

S=${WORKDIR}/${MY_P}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_XML="buildscripts/build.xml"
EANT_BUILD_TARGET="basic"
EANT_DOC_TARGET=""

java_prepare() {
	find -name "*.jar" -delete || die
}

src_compile() {
	local anttask=""

	if use ant; then
		anttask="anttask"
		EANT_GENTOO_CLASSPATH="ant-core"
	fi

	java-pkg-2_src_compile ${anttask}

	if use doc; then
		local EXCLUDE="proguard.gradle:proguard.wtk"
		use ant || EXCLUDE+=":proguard.ant"

		local CP="$([[ -n ${EANT_GENTOO_CLASSPATH} ]] && java-pkg_getjars ${EANT_GENTOO_CLASSPATH})"
		ejavadoc -d javadoc -sourcepath src -classpath "${CP}" -subpackages proguard -exclude "${EXCLUDE}"
	fi
}

src_install() {
	java-pkg_dojar lib/*.jar
	java-pkg_dolauncher ${PN} --main proguard.ProGuard
	java-pkg_dolauncher ${PN}gui --main proguard.gui.ProGuardGUI
	java-pkg_dolauncher ${PN}_retrace --main proguard.retrace.ReTrace

	if use doc; then
		dohtml -r docs/*
		java-pkg_dojavadoc javadoc
	fi

	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc src/*
}
