# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured Java text search engine"
HOMEPAGE="https://lucene.apache.org"
SRC_URI="mirror://apache/lucene/java/archive/${P}-src.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="Apache-1.1"
SLOT="1"

DEPEND="
	>=virtual/jdk-1.6
	test? ( dev-java/ant-junit:0 )"

RDEPEND="
	>=virtual/jre-1.6"

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	eant jar-core $(use_doc javadocs)
}

src_test() {
	java-ant_rewrite-classpath build.xml
	EANT_GENTOO_CLASSPATH="junit ant-core" \
		ANT_TASKS="ant-junit" \
		eant test
}

src_install() {
	einstalldocs
	java-pkg_newjar build/lucene-1.5-rc1-dev.jar

	if use doc; then
		dodoc -r docs/*
		java-pkg_dojavadoc build/docs/api
	fi

	use examples && java-pkg_doexamples src/demo
	use source && java-pkg_dosrc src/java/org
}
