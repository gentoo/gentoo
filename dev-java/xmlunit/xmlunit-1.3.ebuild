# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmlunit/xmlunit-1.3.ebuild,v 1.4 2014/08/10 20:27:49 slyfox Exp $

EAPI="2"

JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
HOMEPAGE="http://xmlunit.sourceforge.net/"
LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 ppc x86"
IUSE=""
RESTRICT="test"

CDEPEND="=dev-java/junit-3.8*"
DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.4
	doc? ( app-text/docbook-xsl-stylesheets )
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
	)
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_DOC_TARGET="users-guide-html javadocs"
EANT_GENTOO_CLASSPATH="junit"
EANT_ANT_TASKS="ant-trax"
EANT_EXTRA_ARGS="-Ddb5.xsl=/usr/share/sgml/docbook/xsl-stylesheets"

# There is a test not passing, see
# https://sourceforge.net/tracker/index.php?func=detail&aid=1875554&group_id=23187&atid=377768

src_test() {
	if use test; then
		ANT_TASKS="ant-junit ant-trax" eant test
	else
		echo "USE=test not enabled, skipping tests."
	fi
}

src_install() {
	java-pkg_newjar "build/lib/${P}.jar"

	dodoc README.txt
	if use doc ; then
		java-pkg_dojavadoc build/doc/api
		dohtml build/doc/userguide/html/*
	fi
	use source && java-pkg_dosrc src/java/org
}
