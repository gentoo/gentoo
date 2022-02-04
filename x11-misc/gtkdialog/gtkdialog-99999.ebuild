# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 xdg-utils

DESCRIPTION="Small utility for fast and easy GUI building"
HOMEPAGE="https://github.com/oshazard/gtkdialog"
EGIT_REPO_URI="https://github.com/oshazard/gtkdialog"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	x11-libs/gtk+:3
	x11-libs/vte:2.91=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/texinfo
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.3-fno-common.patch
	"${FILESDIR}"/${PN}-0.8.3-do_variables_count_widgets.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-gtk3
}

src_compile() {
	emake -C doc stamp-vti
	default
}

src_install() {
	# Stop make install from running gtk-update-icon-cache
	emake DESTDIR="${D}" UPDATE_ICON_CACHE=true install
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
