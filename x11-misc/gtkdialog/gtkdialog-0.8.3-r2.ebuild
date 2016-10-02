# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools

DESCRIPTION="A small utility for fast and easy GUI building"
HOMEPAGE="https://code.google.com/p/gtkdialog/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="glade vte"

RDEPEND="
	x11-libs/gtk+:2
	glade? ( gnome-base/libglade )
	vte? ( x11-libs/vte:0= )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	virtual/yacc
"

DOCS=(
	AUTHORS
	ChangeLog
	TODO
)
PATCHES=(
	"${FILESDIR}"/${PN}-0.8.3-optdeps.patch
)

src_prepare() {
	mv configure.{in,ac} || die
	default
	eautoreconf
}

src_configure() {
	econf $(use_with glade) $(use_with vte)
}

src_install() {
	# Stop make install from running gtk-update-icon-cache
	emake DESTDIR="${D}" UPDATE_ICON_CACHE=true install
}
