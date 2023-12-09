# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.xml.bind:jakarta.xml.bind-api:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta XML Binding API"
HOMEPAGE="https://github.com/jakartaee/jaxb-api"
SRC_URI="https://github.com/jakartaee/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="dev-java/jakarta-activation:2"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"

#   reason: '<>' with anonymous inner classes is not supported in -source 8
#     (use -source 9 or higher to enable '<>' with anonymous inner classes)
RDEPEND="${CP_DEPEND}
	>=virtual/jre-11:*"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )
PATCHES=( "${FILESDIR}/jaxb-api-4.0.2-dropSecurityManager.patch" )

JAVA_RESOURCE_DIRS="api/src/main/resources"
JAVA_SRC_DIR="api/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="jaxb-api-test/src/test/resources"
JAVA_TEST_SRC_DIR="jaxb-api-test/src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}
