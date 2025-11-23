# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${P/rev/REV}"

DESCRIPTION="REV LADSPA plugins package, stereo reverb plugin based on the well-known greverb"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}/source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	tc-export CXX
	sed -i Makefile -e 's/-O2//' -e 's/$(CXX)/$(CXX) $(LDFLAGS)/' || die
}

src_install() {
	dodoc ../AUTHORS ../README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
