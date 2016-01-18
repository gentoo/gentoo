# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PV=${PV/m/.M}
MY_P=${PN}-${MY_PV}

DESCRIPTION="An implementation of XMLPULL V1 API"
HOMEPAGE="http://www.extreme.indiana.edu/xgws/xsoap/xpp/mxp1/index.html"
SRC_URI="http://www.extreme.indiana.edu/dist/java-repository/${PN}/distributions/${MY_P}_src.zip"

LICENSE="Apache-1.1 IBM JDOM LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
		dev-java/junit:0
	)"
RDEPEND=">=virtual/jre-1.6"

S=${WORKDIR}/${MY_P}

JAVA_ANT_ENCODING="ISO-8859-1"

java_prepare() {
	rm -v *.jar || die
	epatch "${FILESDIR}/${P}-build.xml.patch"
}

src_test() {
	ANT_TASKS="ant-junit" \
		eant -Dgentoo.classpath=$(java-pkg_getjars junit) junit_main
}

src_install() {
	java-pkg_newjar build/${MY_P}.jar ${PN}.jar

	dohtml doc/*.html || die
	dodoc doc/*.txt || die

	use doc && java-pkg_dojavadoc doc/api_impl
	use source && java-pkg_dosrc src/java/*
}
