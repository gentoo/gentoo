# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="GNOME hexadecimal editor"
HOMEPAGE="https://wiki.gnome.org/Apps/Ghex"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="2"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=dev-libs/atk-1
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.3.8:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.41.1
	>=sys-devel/gettext-0.17
	app-text/yelp-tools
	virtual/pkgconfig
"
