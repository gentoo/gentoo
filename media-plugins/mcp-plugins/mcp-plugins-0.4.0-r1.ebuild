# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=${P/mcp/MCP}

DESCRIPTION="MCP ladspa plugins package. Includes moogvcf, phaser & chorus"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-0.4.0-makefile.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	einstalldocs

	exeinto /usr/$(get_libdir)/ladspa
	doexe *.so
}
