# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson xdg

DESCRIPTION="Cinnamon's library for the Desktop Menu fd.o specification"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cinnamon-menus/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gtk-doc"

RDEPEND="
	>=dev-libs/glib-2.29.15:2
	>=dev-libs/gobject-introspection-0.9.12:=
"
DEPEND="${RDEPEND}
	dev-libs/gobject-introspection-common
"
BDEPEND="
	>=dev-util/intltool-0.40.6
	sys-devel/gettext
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use debug enable_debug)
		$(meson_use gtk-doc enable_docs)
	)
	meson_src_configure
}
