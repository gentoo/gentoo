# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="MPRISv2 plugin for the DeaDBeeF music player"
HOMEPAGE="https://github.com/DeaDBeeF-Player/deadbeef-mpris2-plugin"
SRC_URI="https://github.com/DeaDBeeF-Player/deadbeef-mpris2-plugin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug"

DEPEND="
	dev-libs/glib:2
	>=media-sound/deadbeef-1.8.0[cover]
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default

	# Remove static library
	rm "${ED}"/usr/$(get_libdir)/deadbeef/mpris.la || die

}
