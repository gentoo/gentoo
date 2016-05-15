# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bind XML to Java code"
HOMEPAGE="http://jibx.sourceforge.net/"
SRC_URI="
	https://repo1.maven.org/maven2/org/${PN}/${PN}-extras/${PV}/${PN}-extras-${PV}-sources.jar
	https://repo1.maven.org/maven2/org/${PN}/${PN}-bind/${PV}/${PN}-bind-${PV}-sources.jar
	https://repo1.maven.org/maven2/org/${PN}/${PN}-run/${PV}/${PN}-run-${PV}-sources.jar
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
IUSE=""

CDEPEND="
	dev-java/bcel:0
	dev-java/xpp3:0
	dev-java/jdom:0
	dev-java/dom4j:1
	dev-java/log4j:0
	dev-java/joda-time:0
	dev-java/ant-core:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_GENTOO_CLASSPATH="
	joda-time
	ant-core
	dom4j-1
	log4j
	jdom
	bcel
	xpp3
"
