# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.xml.bind:jakarta.xml.bind-api:4.0.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta XML Binding API"
HOMEPAGE="https://github.com/eclipse-ee4j/jaxb-api"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="dev-java/jakarta-activation:2"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="api/src/main/java"
JAVA_RESOURCE_DIRS="api/src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="jaxb-api-test/src/test/java"
JAVA_TEST_RESOURCE_DIRS="jaxb-api-test/src/test/resources"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
