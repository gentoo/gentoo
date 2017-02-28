# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.24"

inherit gnome2 vala

DESCRIPTION="Library for code commong to Gnome games"
HOMEPAGE="https://git.gnome.org/browse/libgames-support/"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.19.2:3
	dev-libs/libgee:0.8=
"
DEPEND="${DEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.50.2
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}
