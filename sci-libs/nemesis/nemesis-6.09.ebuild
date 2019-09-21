# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN="exodus"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Enhancement to the EXODUSII finite element database model"
HOMEPAGE="https://github.com/certik/exodus"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="
	sci-libs/exodusii
	sci-libs/netcdf"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}/${PN}

PATCHES=( "${FILESDIR}"/${P}-multilib.patch )

src_prepare() {
	find ../exodus -delete || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
	)
	export NETCDF_DIR="${EPREFIX}/usr/"
	export EXODUS_DIR="${EPREFIX}/usr/"
	cmake-utils_src_configure
}

src_test() {
	"${BUILD_DIR}"/ne_test || die
}
