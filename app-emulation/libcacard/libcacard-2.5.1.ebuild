# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="virtual Common Access Card (CAC) library emulator"
HOMEPAGE="https://www.spice-space.org/"
SRC_URI="https://www.spice-space.org/download/libcacard/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/nss-3.13
	>=dev-libs/glib-2.22
	>=sys-apps/pcsc-lite-1.8"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}"/usr/ -name 'lib*.la' -delete
}
