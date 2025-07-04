# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson xdg-utils

DESCRIPTION="A frontend to easily manage connections to remote filesystems using GIO/GVfs"
HOMEPAGE="
	https://docs.xfce.org/apps/gigolo/start
	https://gitlab.xfce.org/apps/gigolo/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv x86"
IUSE="X"

DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3[X?]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	# defang automagic dependencies
	use X || append-flags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		-Ddocdir=share/doc/${PF}
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	rm "${ED}/usr/share/doc/${PF}/COPYING" || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
