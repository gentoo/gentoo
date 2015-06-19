# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mcp-plugins/mcp-plugins-0.4.0.ebuild,v 1.6 2011/07/15 20:27:21 maekke Exp $

EAPI=4

inherit multilib toolchain-funcs

MY_P=${P/mcp/MCP}

DESCRIPTION="MCP ladspa plugins package. Includes moogvcf, phaser & chorus"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
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
