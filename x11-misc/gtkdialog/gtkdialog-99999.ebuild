# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools git-r3

DESCRIPTION="A small utility for fast and easy GUI building"
HOMEPAGE="https://github.com/oshazard/gtkdialog"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk3"

RDEPEND="
	!gtk3? (
		x11-libs/gtk+:2
		x11-libs/vte:0=
	)
	gtk3? (
		x11-libs/gtk+:3
		x11-libs/vte:2.91=
	)
"
DEPEND="
	${RDEPEND}
	sys-apps/texinfo
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk3)
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
