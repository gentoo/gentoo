# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc examples source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="http://lucene.apache.org"
SRC_URI="mirror://apache/lucene/java/archive/${P}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="1"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	test? (
		=dev-java/junit-3*
		dev-java/ant-junit
	)"
RDEPEND=">=virtual/jdk-1.4"

src_unpack() {
	unpack ${A}

	cd "${S}/lib" || die
	rm -v *.jar || die
}

src_compile() {
	eant jar-core $(use_doc javadocs)
}

src_test() {
	java-ant_rewrite-classpath build.xml
	EANT_GENTOO_CLASSPATH="junit ant-core" ANT_TASKS="ant-junit" eant test
}

src_install() {
	dodoc CHANGES.txt README.txt || die
	java-pkg_newjar build/lucene-1.5-rc1-dev.jar

	if use doc; then
		dohtml -r docs/*
		java-pkg_dojavadoc build/docs/api
	fi
	use examples && java-pkg_doexamples src/demo
	use source && java-pkg_dosrc src/java/org
}
