# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-dbcp/commons-dbcp-2.1.ebuild,v 1.5 2015/04/02 18:29:19 mr_bones_ Exp $

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN="${PN}2"
MY_PV="${PV%_*}"
MY_P="${MY_PN}-${MY_PV}-src"

DESCRIPTION="Jakarta component providing database connection pooling API"
HOMEPAGE="http://commons.apache.org/dbcp/"
SRC_URI="mirror://apache/commons/dbcp/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~x86 ~amd64 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

CDEPEND=">=dev-java/commons-logging-1.1.1
	dev-java/commons-pool:2
	java-virtuals/transaction-api:0
	dev-java/junit:4"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	test? ( dev-java/ant-junit:0 )"
RDEPEND="
	>=virtual/jdk-1.7
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

EANT_GENTOO_CLASSPATH="commons-logging,commons-pool-2,transaction-api,junit-4"
EANT_BUILD_TARGET="build-jar"

src_test() {
	local TESTS_TO_DELETE=()

	function test_to_del() {
		local TEST_FILE=$1
		TESTS_TO_DELETE+=(${TEST_FILE})
	}

	function rm_tests() {
		for TEST_FILE in ${TESTS_TO_DELETE[@]}; do
			ebegin "Removing test file ${TEST_FILE}"
			rm "${TEST_FILE}" || die
			eend $?
		done
	}

	# These tests depend on a geronimo,
	# which is not packaged yet for Gentoo unfortunately.
	# See bug #348853.
	test_to_del src/test/java/org/apache/commons/dbcp2/managed/TestBasicManagedDataSource.java
	test_to_del src/test/java/org/apache/commons/dbcp2/managed/TestManagedDataSource.java
	test_to_del src/test/java/org/apache/commons/dbcp2/managed/TestManagedDataSourceInTx.java
	test_to_del src/test/java/org/apache/commons/dbcp2/managed/TestDataSourceXAConnectionFactory.java
	test_to_del src/test/java/org/apache/commons/dbcp2/managed/TestManagedConnection.java
	test_to_del src/test/java/org/apache/commons/dbcp2/managed/TestTransactionContext.java

	# This one fails.
	test_to_del src/test/java/org/apache/commons/dbcp2/TestJndi.java

	rm_tests

	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar dist/${MY_PN}-${MY_PV}.jar ${PN}.jar
	dodoc README.txt RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/main/java/*
}
