# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Library of matchers for building test expressions"
HOMEPAGE="https://hamcrest.org/JavaHamcrest/"
SRC_URI="https://github.com/${MY_PN}/JavaHamcrest/archive/${MY_PN}-java-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/JavaHamcrest-${MY_PN}-java-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-solaris"

DEPEND="
	>=virtual/jdk-1.8:*
	source? ( app-arch/zip )
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="${PN}/src"

PATCHES=(
	# https://bugs.gentoo.org/751379
	"${FILESDIR}"/hamcrest-core-1.1-java-11.patch
)

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean
}
