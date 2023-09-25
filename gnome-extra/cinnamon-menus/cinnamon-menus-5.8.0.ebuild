# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="Cinnamon's library for the Desktop Menu fd.o specification"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-menus"
SRC_URI="https://github.com/linuxmint/cinnamon-menus/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="gtk-doc"

RDEPEND="
	>=dev-libs/glib-2.29.15:2
	>=dev-libs/gobject-introspection-1.58.3:=
"
DEPEND="
	${RDEPEND}
	dev-libs/gobject-introspection-common
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig

	gtk-doc? ( dev-util/gtk-doc )
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc enable_docs)
	)
	meson_src_configure
}
