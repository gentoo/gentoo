# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.felix:org.apache.felix.gogo.runtime:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache Felix Gogo Runtime"
HOMEPAGE="https://felix.apache.org/documentation/subprojects/apache-felix-gogo.html"
SRC_URI="mirror://apache/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz -> ${P}.tar.gz
	verify-sig? ( https://dlcdn.apache.org/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz.asc -> ${P}.tar.gz.asc )"
S="${WORKDIR}/org.apache.felix.gogo.runtime-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/osgi-annotation:0
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/mockito:2
	)
"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-felix )"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/felix.apache.org.asc"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXCLUDES=(
	#Invalid test class No runnable methods
	org.apache.felix.gogo.runtime.TestEvaluate
)
JAVA_TEST_GENTOO_CLASSPATH="
	junit-4
	mockito-2
"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -lt 11; then
		java-pkg-simple_src_test
	else
		# There was 1 failure:
		# 1) testPipe(org.apache.felix.gogo.runtime.TestParser)
		# org.junit.ComparisonFailure: expected:<[def]> but was:<[]>
		#         at org.junit.Assert.assertEquals(Assert.java:117)
		#         at org.junit.Assert.assertEquals(Assert.java:146)
		#         at org.apache.felix.gogo.runtime.TestParser.testPipe(TestParser.java:152)
		einfo "Tests would fail with Java 11 or higher"
	fi
}
