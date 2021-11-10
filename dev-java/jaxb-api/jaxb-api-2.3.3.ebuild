# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/jaxb-api/archive/refs/tags/2.3.3.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jaxb-api-2.3.3.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.xml.bind:jakarta.xml.bind-api:2.3.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta XML Binding API"
HOMEPAGE="https://github.com/eclipse-ee4j/jaxb-api"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

# Common dependencies
# POM: pom.xml
# jakarta.activation:jakarta.activation-api:1.2.2 -> >=dev-java/jakarta-activation-api-2.0.1:0
# jakarta.xml.bind:jakarta.xml.bind-api:2.3.3 -> >=dev-java/jaxb-api-2.3.3:0

CDEPEND="dev-java/jakarta-activation-api:1"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{LICENSE,NOTICE,README}.md )

S="${WORKDIR}/${P}/${PN}"

JAVA_GENTOO_CLASSPATH="jakarta-activation-api-1"
JAVA_GENTOO_CLASSPATH_EXTRA="jaxb-api.jar"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="../${PN}-test/src/test/java"
JAVA_TEST_RESOURCE_DIRS="../${PN}-test/src/test/resources"

src_test() {
	# Suppress tests for vm_version 1.8 (too many test failures)
	# see https://bugs.gentoo.org/796995
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" != "1.8" ]] ; then
		java-pkg-simple_src_test
	fi
}

src_install() {
	default
	java-pkg-simple_src_install
}
