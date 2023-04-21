# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.ws.rs:jakarta.ws.rs-api:2.1.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta RESTful Web Services API"
HOMEPAGE="https://github.com/jakartaee/rest"
SRC_URI="https://github.com/jakartaee/rest/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rest-${PV}/${PN}"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-11:*
	dev-java/jakarta-activation-api:1
	dev-java/jaxb-api:2
	test? (
		dev-java/jaxb-runtime:2
		dev-java/mockito:4
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-1,jaxb-api-2"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="jaxb-runtime-2,junit-4,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# The default test selection of java-pkg-simple would omit
	# "javax.ws.rs.core.AbstractMultivaluedMapTest"
	pushd src/test/java > /dev/null || die
		local JAVA_TEST_RUN_ONLY=$(find * -type f -name "*Test.java" )
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd > /dev/null || die
	java-pkg-simple_src_test
}
