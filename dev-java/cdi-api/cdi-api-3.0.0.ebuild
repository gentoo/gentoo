# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom cdi-3.0.0/api/pom.xml --download-uri https://github.com/eclipse-ee4j/cdi/archive/refs/tags/3.0.0.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild cdi-api-3.0.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.enterprise:jakarta.enterprise.cdi-api:3.0.0"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="APIs for CDI (Contexts and Dependency Injection for Java)"
HOMEPAGE="http://cdi-spec.org"
SRC_URI="https://github.com/eclipse-ee4j/cdi/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/eclipse-ee4j/ejb-api/archive/refs/tags/4.0.0-RELEASE.tar.gz -> ejb-api-4.0.0.tar.gz
	https://github.com/eclipse-ee4j/jta-api/archive/refs/tags/2.0.0.tar.gz -> jta-api-2.0.0.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

# ===============================================
# Command line suite
# Total tests run: 57, Failures: 7, Skips: 0
# ===============================================
#	RESTRICT="test"

# Common dependencies
# POM: cdi-${PV}/api/pom.xml
# jakarta.el:jakarta.el-api:4.0.0 -> >=dev-java/jakarta-el-api-4.0.0:0
# jakarta.inject:jakarta.inject-api:2.0.0 -> >=dev-java/injection-api-2.0.1:0
# jakarta.interceptor:jakarta.interceptor-api:2.0.0 -> >=dev-java/interceptor-api-2.0.0:0

CDEPEND="
	dev-java/injection-api:0
	dev-java/interceptor-api:0
	dev-java/jakarta-el-api:0
"

# Compile dependencies
# POM: cdi-${PV}/api/pom.xml
# jakarta.ejb:jakarta.ejb-api:4.0.0 -> >=dev-java/ejb-api-4.0.0:0
# jakarta.transaction:jakarta.transaction-api:2.0.0 -> >=dev-java/jta-api-2.0.0:0
# POM: cdi-${PV}/api/pom.xml
# test? org.testng:testng:6.9.10 -> >=dev-java/testng-6.9.10:0

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
# There is cyclic dependency of jta-api and cdi-api
#	dev-java/ejb-api:0"
#	dev-java/jta-api:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"
BDEPEND="app-arch/zip"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md ../LICENSE.txt )

S="${WORKDIR}/cdi-${PV}/api"

JAVA_GENTOO_CLASSPATH="jakarta-el-api,injection-api,interceptor-api"
#	JAVA_CLASSPATH_EXTRA="ejb-api,jta-api"
JAVA_SRC_DIR=(
	"src/main/java"
	# Solve the cyclic dependency by adding the sources here
	"../../ejb-api-4.0.0-RELEASE/api/src/main/java/jakarta/ejb"
	"../../jta-api-2.0.0/api/src/main/java/jakarta/transaction"
)
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="testng"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_compile() {
	java-pkg-simple_src_compile
	# Remove dependencie's classes
	zip --delete cdi-api.jar \
		"jakarta/ejb/*" "jakarta/transaction/*" || die "cleaning after tests failed"
}

src_install() {
	default
	java-pkg-simple_src_install
}
