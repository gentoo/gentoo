# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/fil-plugins/fil-plugins-0.3.0.ebuild,v 1.4 2011/03/03 11:23:30 tomka Exp $

inherit multilib toolchain-funcs eutils

MY_P=${P/fil/FIL}

DESCRIPTION="FIL-plugins ladspa plugin package. Filters by Fons Adriaensen"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-makefile.patch"
}

src_compile() {
	tc-export CXX
	emake || die
}

src_install() {
	dodoc AUTHORS README || die
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so || die
}
