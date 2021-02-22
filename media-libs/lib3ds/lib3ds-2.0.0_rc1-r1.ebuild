# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="20080909"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="library for managing 3D-Studio Release 3 and 4 .3DS files"
HOMEPAGE="https://code.google.com/p/lib3ds/"
SRC_URI="https://lib3ds.googlecode.com/files/${MY_P}.zip"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="static-libs"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-underlinking-no-autoreconf.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		rm "${ED}/usr/$(get_libdir)/${PN}.la" || die
	fi
}
