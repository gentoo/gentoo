# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org meson

DESCRIPTION="A nautilus extension for sending files to locations"
HOMEPAGE="https://git.gnome.org/browse/nautilus-sendto/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.25.9:2"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.8
	dev-libs/appstream-glib
	virtual/pkgconfig
"

pkg_postinst() {
	if ! has_version "gnome-base/nautilus[sendto]"; then
		einfo "Note that ${CATEGORY}/${PN} is meant to be used as a helper by gnome-base/nautilus[sendto]"
	fi
}
