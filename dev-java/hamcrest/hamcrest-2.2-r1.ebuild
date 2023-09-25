# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.hamcrest:hamcrest:2.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core API and libraries of hamcrest matcher framework."
HOMEPAGE="https://hamcrest.org/JavaHamcrest/"
SRC_URI="https://github.com/${PN}/JavaHamcrest/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/JavaHamcrest-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

PATCHES=( "${FILESDIR}"/hamcrest-2.2-java-11.patch )

DOCS=( {CHANGES,README}.md )

JAVA_AUTOMATIC_MODULE_NAME="org.hamcrest"
JAVA_SRC_DIR="hamcrest/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="hamcrest/src/test/java"

src_prepare() {
	default
	java-pkg-2_src_prepare
}
