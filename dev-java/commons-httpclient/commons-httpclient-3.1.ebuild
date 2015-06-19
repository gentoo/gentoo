# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-httpclient/commons-httpclient-3.1.ebuild,v 1.7 2010/01/03 20:25:49 fauli Exp $

JAVA_PKG_IUSE="doc examples source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="The Jakarta Commons HttpClient library"
HOMEPAGE="http://hc.apache.org/"
SRC_URI="mirror://apache/httpcomponents/${PN}/source/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
# doesn't work on IBM JDK, bug #176133
RESTRICT="test"

COMMON_DEPEND="
	dev-java/commons-logging
	dev-java/commons-codec"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )
	${COMMON_DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# the generated docs go to docs/api
	rm -rf docs/apidocs

	# don't do javadoc always
	sed -i -e 's/depends="compile,doc"/depends="compile"/' build.xml || die
	sed -i -e '/link/ d' build.xml || die
	mkdir lib && cd lib
	java-pkg_jar-from commons-logging
	java-pkg_jar-from commons-codec
	java-pkg_filter-compiler jikes
}

EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="doc"

src_test() {
	java-pkg_jar-from --into lib junit
	eant test
}

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
