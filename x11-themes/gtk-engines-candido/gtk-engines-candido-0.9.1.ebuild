# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools eutils

MY_P="candido-engine-${PV}"

DESCRIPTION="Candido GTK+ 2.x Theme Engine"
HOMEPAGE="https://sourceforge.net/projects/candido.berlios/"
SRC_URI="mirror://sourceforge/candido.berlios/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog CREDITS NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-glib-2.31.patch
	eautoreconf # required for interix
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
