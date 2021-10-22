# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${P/vco/VCO}"

DESCRIPTION="SAW-VCO ladspa plugin package. Anti-aliased oscillators"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	tc-export CXX
	sed -i -e "s/-O3//" \
		-e "s/g++/$(tc-getCXX) ${LDFLAGS}/" Makefile || die
}

src_install() {
	dodoc AUTHORS README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
