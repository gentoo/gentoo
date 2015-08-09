# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

DESCRIPTION="utility that allows you to specify window properties in blackbox"
HOMEPAGE="http://sourceforge.net/projects/bbtools"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86 ~x86-fbsd"
IUSE="debug"

DOCS=( AUTHORS BUGS ChangeLog NEWS README TODO data/README.bbappconf )

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-sigsegv.diff \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-docs.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}
