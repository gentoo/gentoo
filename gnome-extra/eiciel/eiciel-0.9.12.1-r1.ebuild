# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="https://rofi.roger-ferrer.org/eiciel/"
SRC_URI="https://rofi.roger-ferrer.org/eiciel/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nautilus xattr"

RDEPEND="
	>=sys-apps/acl-2.2.32
	dev-cpp/gtkmm:3.0
	nautilus? ( >=gnome-base/nautilus-3 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gettext-0.18.1
"

PATCHES=(
	# attr/xattr.h is deprecated. Use sys/xattr.h instead (from 'master')
	"${FILESDIR}"/${P}-xattr-header.patch
)

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-gnome-version=3 \
		$(use_enable nautilus nautilus-extension) \
		$(use_enable xattr user-attributes)
}
