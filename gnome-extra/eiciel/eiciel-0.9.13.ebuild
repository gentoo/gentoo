# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="https://rofi.roger-ferrer.org/eiciel/"
SRC_URI="https://rofi.roger-ferrer.org/eiciel/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nautilus xattr"

DEPEND="
	>=sys-apps/acl-2.2.32
	dev-cpp/gtkmm:3.0
	>=dev-cpp/glibmm-2.50:2
	nautilus? ( >=gnome-base/nautilus-3 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=sys-devel/gettext-0.18.1
"

src_unpack() {
	default

	# https://github.com/rofirrim/eiciel/pull/6
	cp "${FILESDIR}"/eiciel_participant_target.hpp "${S}"/src/
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-gnome-version=3 \
		$(use_enable nautilus nautilus-extension) \
		$(use_enable xattr user-attributes)
}
