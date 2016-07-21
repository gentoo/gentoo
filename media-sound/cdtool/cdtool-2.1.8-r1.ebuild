# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils

DESCRIPTION="collection of command-line utilities to control cdrom devices"
HOMEPAGE="http://hinterhof.net/cdtool/"
SRC_URI="http://hinterhof.net/cdtool/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="!media-sound/cdplay"

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	sed -i \
		-e '/INSTALL/s:-o root::' \
		-e '/LINKTARGET/s:/lib/:/$(notdir $(libdir))/:' \
		-e '/^install-links:/s:$: install-files:' \
		Makefile.in || die
}
