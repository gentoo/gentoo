# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://xmlunit.sourceforge.net/"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 ppc ppc64 x86"

CDEPEND="dev-java/junit:0"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip:0
	doc? ( app-text/docbook-xsl-stylesheets:0 )
	test? (
		dev-java/ant-junit:0
		dev-java/ant-trax:0
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="junit"

EANT_DOC_TARGET="users-guide-html javadocs"
EANT_ANT_TASKS="ant-trax"
EANT_EXTRA_ARGS="-Ddb5.xsl=/usr/share/sgml/docbook/xsl-stylesheets"

src_test() {
	ANT_TASKS="ant-junit ant-trax" eant test
}

src_install() {
	java-pkg_newjar "build/lib/${P}.jar"

	dodoc README.txt

	if use doc; then
		java-pkg_dojavadoc build/doc/api
		dohtml build/doc/userguide/html/*
	fi

	use source && java-pkg_dosrc src/java/org
}
