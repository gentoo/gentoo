# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom hamcrest-2.2.pom --download-uri https://github.com/hamcrest/JavaHamcrest/archive/v2.2.tar.gz --slot 0 --keywords "~amd64" --ebuild hamcrest-2.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.hamcrest:hamcrest:2.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core API and libraries of hamcrest matcher framework."
HOMEPAGE="http://hamcrest.org/JavaHamcrest/"
SRC_URI="https://github.com/${PN}/JavaHamcrest/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

S="${WORKDIR}/JavaHamcrest-${PV}"

JAVA_SRC_DIR="hamcrest/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="hamcrest/src/test/java"

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
