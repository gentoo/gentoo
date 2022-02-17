# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/digester/source/commons-digester3-3.2-src.tar.gz --slot 3.2 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-digester3.2-r3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-digester3:3.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Reads XML configuration files to provide initialization of various Java objects"
HOMEPAGE="https://commons.apache.org/digester/"
SRC_URI="mirror://apache/commons/digester/source/${PN}3-${PV}-src.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="amd64 ppc64 x86"

# 1) atomWithNamespaceParse(org.apache.commons.digester3.xmlrules.SetNamespaceURITestCase)
# java.net.UnknownHostException: commons.apache.org
PROPERTIES="test_network"
RESTRICT="test"

# Common dependencies
# POM: pom.xml
# cglib:cglib:2.2.2 -> >=dev-java/cglib-3.3.0:3
# commons-beanutils:commons-beanutils:1.8.3 -> >=dev-java/commons-beanutils-1.9.4:1.7
# commons-logging:commons-logging:1.1.1 -> >=dev-java/commons-logging-1.2:0

CP_DEPEND="
	>=dev-java/cglib-3.3.0:3
	>=dev-java/commons-beanutils-1.9.4:1.7
	>=dev-java/commons-logging-1.2:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {LICENSE,NOTICE,RELEASE-NOTES}.txt )

S="${WORKDIR}/commons-digester3-${PV}-src"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_test() {
	pushd src/test/java || die
		# Exclusions according to 226,229 pom.xml
		local JAVA_TEST_RUN_ONLY=$(find * -name "*TestCase.java" ! -name "Abstract*.java" ! -name "TestBean.java" ! -name "TestRule.java" ! -name "TestRuleSet.java")
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd

	# Testing with java-17 throws too many test failures
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" != "17" ]] ; then
		java-pkg-simple_src_test
	fi
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
