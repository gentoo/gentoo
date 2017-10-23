# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit git-r3 gnome2-utils

DESCRIPTION="Desktop menu for Compiz"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="https://github.com/compiz-reloaded/compiz-boxmenu.git"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
		dev-python/lxml
		dev-python/pygobject:2
		dev-python/pyxdg
		dev-python/pygtk
"

DEPEND="${RDEPEND}
		dev-libs/dbus-glib
		sys-apps/dbus
		>=dev-libs/glib-2
		>=x11-libs/libwnck-2.22.0:1
"

src_prepare() {
	default
	sed -i 's/^\(Categories\)=.*$/\1=Utility;/' Compiz-Boxmenu-Editor.desktop || die "Sed failed!"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
