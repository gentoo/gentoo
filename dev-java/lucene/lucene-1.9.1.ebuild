# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/lucene/lucene-1.9.1.ebuild,v 1.7 2013/12/28 19:09:56 robbat2 Exp $

# This ebuild only builds the core of Lucene
# It does not build any optional component (contributions)

JAVA_PKG_IUSE="test source doc"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="http://lucene.apache.org"
SRC_URI="mirror://apache/lucene/java/archive/${P}-src.tar.gz"
LICENSE="Apache-1.1"
SLOT="1.9"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/junit dev-java/ant-junit )"

RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf contrib # we remove entirely the contrib directory
	epatch "${FILESDIR}/disable-contrib.patch"

	if use test; then
		mkdir lib
		java-ant_rewrite-classpath "common-build.xml"
	fi
}

src_compile() {
	eant jar-core $(use_doc javadocs)
}

src_test() {
	java-ant_rewrite-classpath common-build.xml
	EANT_GENTOO_CLASSPATH="junit ant-core" ANT_TASKS="ant-junit" eant test
}

src_install() {
	dodoc CHANGES.txt README.txt
	# WTF is with the jar version below
	java-osgi_newjar-fromfile "build/lucene-core-1.9.2-dev.jar" \
		"${FILESDIR}/lucene-manifest" "Apache Lucene"

	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/java/org
}
