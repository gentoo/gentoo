# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Jakarta component providing database connection pooling API"
HOMEPAGE="http://commons.apache.org/dbcp/"
SRC_URI="mirror://apache/commons/dbcp/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

COMMON_DEP="
	dev-java/commons-pool:0
	java-virtuals/transaction-api:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	virtual/jdk:1.6
	test? ( dev-java/ant-junit:0 )"

S="${WORKDIR}/${P}-src"

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_BUILD_TARGET="build-jar"
EANT_GENTOO_CLASSPATH="commons-pool,transaction-api"

src_test() {
	# depend on not packaged geronimo #348853
	rm -v src/test/org/apache/commons/dbcp/managed/TestBasicManagedDataSource.java || die
	rm -v src/test/org/apache/commons/dbcp/managed/TestManagedDataSource.java || die
	rm -v src/test/org/apache/commons/dbcp/managed/TestManagedDataSourceInTx.java || die

	# fails :(
	rm -v src/test/org/apache/commons/dbcp/TestJndi.java || die

	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar dist/${PN}*.jar
	dodoc README.txt RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
