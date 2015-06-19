# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/amb-plugins/amb-plugins-0.8.1.ebuild,v 1.3 2011/12/13 23:32:33 ago Exp $

EAPI=3

inherit base multilib toolchain-funcs eutils

MY_P=${P/amb/AMB}

DESCRIPTION="AMB-plugins ladspa plugin package. Filters by Fons Adriaensen"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-Makefile.patch" )

src_compile() {
	tc-export CXX
	emake || die
}

src_install() {
	dodoc AUTHORS README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
