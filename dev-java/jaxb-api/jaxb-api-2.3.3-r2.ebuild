# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.xml.bind:jakarta.xml.bind-api:2.3.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta XML Binding API"
HOMEPAGE="https://github.com/jakartaee/jaxb-api"
SRC_URI="https://github.com/jakartaee/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="EPL-1.0"
SLOT="2"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="dev-java/jakarta-activation-api:1"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {LICENSE,NOTICE,README}.md )
PATCHES=( "${FILESDIR}/jaxb-api-2.3.3-dropSecurityManager.patch" )

JAVA_GENTOO_CLASSPATH_EXTRA="jaxb-api.jar"
JAVA_RESOURCE_DIRS="${PN}/src/main/resources"
JAVA_SRC_DIR="${PN}/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="${PN}-test/src/test/resources"
JAVA_TEST_SRC_DIR="${PN}-test/src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}
