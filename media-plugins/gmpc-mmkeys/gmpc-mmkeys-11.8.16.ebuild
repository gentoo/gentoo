# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vala

DESCRIPTION="Bind multimedia keys via gnome settings daemon"
HOMEPAGE="http://gmpc.wikia.com/wiki/Plugins"
SRC_URI="http://download.sarine.nl/Programs/gmpc/11.8/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/dbus-glib
	>=media-sound/gmpc-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	virtual/pkgconfig"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# plugins only
	find "${D}" -name '*.la' -delete || die
}
