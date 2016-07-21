# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="A GTK+ unit conversion tool"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
IUSE="nls"
KEYWORDS="~amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-libs/libxml2:2=
	sci-libs/libqalculate:0=
	x11-libs/gdk-pixbuf:2=
	x11-libs/gtk+:2=
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-cln-config.patch \
		"${FILESDIR}"/${P}-desktop.patch
	eautoconf
}
