# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects"
HOMEPAGE="https://commons.apache.org/digester/"
SRC_URI="mirror://apache/commons/digester/source/${PN}3-${PV}-src.tar.gz -> ${P}.tar.gz
	verify-sig? ( mirror://apache/commons/digester/source/${PN}3-${PV}-src.tar.gz.asc -> ${P}.tar.gz.asc )"
S="${WORKDIR}/commons-digester3-${PV}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64"

# 1) atomWithNamespaceParse(org.apache.commons.digester3.xmlrules.SetNamespaceURITestCase)
# java.net.UnknownHostException: commons.apache.org
PROPERTIES="test_network"
RESTRICT="test"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"

CP_DEPEND="
	>=dev-java/cglib-3.3.0-r3:0
	>=dev-java/commons-beanutils-1.11.0:0
	>=dev-java/commons-logging-1.3.5:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {NOTICE,RELEASE-NOTES}.txt )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"

src_test() {
	# Exclusions according to 226,229 pom.xml
	local JAVA_TEST_RUN_ONLY=$(find src/test/java \
		-name "*TestCase.java" \
		! -name "Abstract*.java" \
		! -name "TestBean.java" \
		! -name "TestRule.java" \
		! -name "TestRuleSet.java" -printf '%P\n')
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	fi

	java-pkg-simple_src_test
}
