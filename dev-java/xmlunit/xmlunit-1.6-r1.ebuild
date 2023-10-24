# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="xmlunit:xmlunit:1.6"

inherit java-pkg-2 java-ant-2

DESCRIPTION="XMLUnit extends JUnit and NUnit to enable unit testing of XML"
HOMEPAGE="https://sourceforge.net/projects/xmlunit/ https://www.xmlunit.org"
SRC_URI="mirror://sourceforge/project/xmlunit/xmlunit%20for%20Java/XMLUnit%20for%20Java%20${PV}/${P}-src.zip"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 ~arm64 ppc64 x86"

CDEPEND="dev-java/junit:0"

DEPEND=">=virtual/jdk-1.8:*
	app-arch/unzip:0
	doc? ( app-text/docbook-xsl-stylesheets:0 )
	test? (
		dev-java/ant-junit:0
		dev-java/ant-core:0
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="junit"

EANT_DOC_TARGET="users-guide-html javadocs"
EANT_ANT_TASKS="ant-core"
EANT_EXTRA_ARGS="-Ddb5.xsl=/usr/share/sgml/docbook/xsl-stylesheets"

src_test() {
	ANT_TASKS="ant-junit ant-core" eant test
}

src_install() {
	java-pkg_newjar "build/lib/${P}.jar"

	dodoc README.txt

	if use doc; then
		java-pkg_dojavadoc build/doc/api
		docinto html
		dodoc -r build/doc/userguide/html/
	fi

	use source && java-pkg_dosrc src/java/org
}
