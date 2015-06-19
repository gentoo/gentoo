# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-httpclient/commons-httpclient-3.1-r1.ebuild,v 1.3 2015/06/17 07:31:49 ago Exp $

EAPI=5

JAVA_PKG_IUSE="doc examples source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="The Jakarta Commons HttpClient library"
HOMEPAGE="http://hc.apache.org/"
SRC_URI="mirror://apache/httpcomponents/${PN}/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

# doesn't work with IBM JDK, bug #176133
RESTRICT="test"

CDEPEND="dev-java/commons-logging:0
	dev-java/commons-codec:0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/ant-junit:0 )
	${CDEPEND}"

JAVA_ANT_ENCODING="ISO-8859-1"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-logging,commons-codec"
EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="doc"

java_prepare() {
	# patch against CVE-2012-{5783,6153}. See bug 442292.
	epatch "${FILESDIR}"/"${P}-SSLProtocolSocketFactory.java.patch"

	# generated docs go into docs/api
	rm -rf docs/apidocs

	# remove javadoc task from compile task
	sed -i -e 's/depends="compile,doc"/depends="compile"/' build.xml || die
	sed -i -e '/link/ d' build.xml || die

	mkdir lib && cd lib
	java-pkg_filter-compiler jikes
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit"
EANT_TEST_TARGET="test"

src_install() {
	java-pkg_dojar dist/${PN}.jar

	# contains both html docs and javadoc in correct subdir
	if use doc ; then
		java-pkg_dojavadoc dist/docs/api
		java-pkg_dohtml -r dist/docs/*
	fi
	use source && java-pkg_dosrc src/java/*
	use examples && java-pkg_doexamples src/examples
}
