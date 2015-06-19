# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vco-plugins/vco-plugins-0.3.0.ebuild,v 1.8 2011/06/28 00:01:31 radhermit Exp $

EAPI=4

inherit multilib toolchain-funcs

MY_P=${P/vco/VCO}

DESCRIPTION="SAW-VCO ladspa plugin package. Anti-aliased oscillators"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	tc-export CXX
	sed -i -e "s/-O3//" \
		-e "s/g++/$(tc-getCXX) ${LDFLAGS}/" Makefile || die "sed failed"
}

src_install() {
	dodoc AUTHORS README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
