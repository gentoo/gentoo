# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/lucene/lucene-2.3.0.ebuild,v 1.7 2013/12/28 19:09:57 robbat2 Exp $

JAVA_PKG_IUSE="doc source test"
JAVA_PKG_BSFIX_ALL="no"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml"

inherit java-pkg-2 java-ant-2

DESCRIPTION="High-performance, full-featured text search engine written entirely in Java"
HOMEPAGE="http://lucene.apache.org"
# when doing version bump, SRC_URI of the previous version should most probably
# be changed to java/archive/ !
SRC_URI="mirror://apache/lucene/java/archive/${P}-src.tar.gz
		 mirror://apache/lucene/java/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="2.3"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	dev-java/ant-nodeps
	dev-java/javacc
	test? ( dev-java/ant-junit =dev-java/junit-3* )"
RDEPEND=">=virtual/jdk-1.4"

src_compile() {
	# regenerate javacc files just because we can
	# put javacc.jar on ant's classpath here even when <javacc> task
	# doesn't use it - it's to fool the <available> test, first time
	# it's useful not to have ignoresystemclasses=true...
	ANT_TASKS="ant-nodeps javacc" eant \
		-Djavacc.home=/usr/share/javacc/lib javacc
	ANT_TASKS="none" eant -Dversion=${PV} jar-core jar-demo $(use_doc javadocs-core javadocs-demo)
}

src_test() {
	java-ant_rewrite-classpath common-build.xml
	EANT_GENTOO_CLASSPATH="junit ant-core" ANT_TASKS="ant-junit" eant test-core
}

src_install() {
	dodoc CHANGES.txt README.txt || die
	java-pkg_newjar build/${PN}-core-${PV}.jar ${PN}-core.jar
	java-pkg_newjar build/${PN}-demos-${PV}.jar ${PN}-demos.jar

	if use doc; then
		dohtml -r docs/* || die
		# for the core and demo subdirs
		java-pkg_dohtml -r build/docs/api
	fi
	use source && java-pkg_dosrc src/java/org
}
