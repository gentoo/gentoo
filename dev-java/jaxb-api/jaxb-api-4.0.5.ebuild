# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta XML Binding API"
HOMEPAGE="https://github.com/jakartaee/jaxb-api"
SRC_URI="https://github.com/jakartaee/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="EPL-1.0"
SLOT="4"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND="dev-java/jakarta-activation:2"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
"

#   reason: '<>' with anonymous inner classes is not supported in -source 8
#     (use -source 9 or higher to enable '<>' with anonymous inner classes)
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-11:*
"

DOCS=( {CONTRIBUTING,NOTICE,README}.md )
PATCHES=( "${FILESDIR}/jaxb-api-4.0.2-dropSecurityManager.patch" )

JAVA_RESOURCE_DIRS="api/src/main/resources"
JAVA_SRC_DIR="api/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="jaxb-api-test/src/test/resources"
JAVA_TEST_SRC_DIR="jaxb-api-test/src/test/java"
