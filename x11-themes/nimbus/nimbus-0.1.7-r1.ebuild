# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

AUTOTOOLS_AUTO_DEPEND=no
inherit autotools xdg

DESCRIPTION="The default OpenSolaris theme (GTK+ 2.x engine, icon- and metacity theme)"
HOMEPAGE="http://dlc.sun.com/osol/jds/downloads/extras/nimbus/"
SRC_URI="http://dlc.sun.com/osol/jds/downloads/extras/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="gtk minimal"

DEPEND="gtk? ( x11-libs/gtk+:2 )"
RDEPEND="
	${DEPEND}
	!minimal? (
		|| (
			x11-themes/adwaita-icon-theme
			x11-themes/tango-icon-theme
		)
	)"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	x11-misc/icon-naming-utils
	!gtk? ( ${AUTOTOOLS_DEPEND} )"

PATCHES=( "${FILESDIR}"/${PN}-0.1.7-fix-themes.patch )

src_prepare() {
	xdg_src_prepare

	echo light-index.theme.in >> po/POTFILES.skip || die
	echo dark-index.theme.in >> po/POTFILES.skip || die

	if ! use gtk; then
		sed -e '/GTK2/d' \
			-e '/^gtk-engine/d' \
			-e '/^SUBDIRS/s:gtk-engine ::' \
			-i configure.in Makefile.am || die
		mv configure.{in,ac} || die
		eautoreconf
	fi
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
