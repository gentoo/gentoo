# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

RELDATE="2016-0711"
RELEASE="${PN}-v${PV}-${RELDATE}"

DESCRIPTION="Clustering Database at High Identity with Tolerance"
HOMEPAGE="http://weizhong-lab.ucsd.edu/cd-hit/"
SRC_URI="https://github.com/weizhongli/cdhit/releases/download/V${PV}/${RELEASE}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${RELEASE}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.6-fix-perl-shebangs.patch
	"${FILESDIR}"/${PN}-4.6.6-fix-build-system.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_compile() {
	tc-export CXX
	emake openmp=$(usex openmp)
}

src_install() {
	dodir /usr/bin
	PREFIX="${EPREFIX}"/usr/bin default

	dodoc doc/*.pdf
}
