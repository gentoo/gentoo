# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

MY_P=caps-${PV}

DESCRIPTION="The CAPS Audio Plugin Suite - LADSPA plugin suite"
HOMEPAGE="http://quitte.de/dsp/caps.html"
SRC_URI="http://quitte.de/dsp/caps_${PV}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake \
		ARCH="" \
		CC="$(tc-getCXX)" \
		CFLAGS="${CXXFLAGS} -fPIC -DPIC" \
		_LDFLAGS="-shared ${LDFLAGS}"
}

multilib_src_install() {
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}

multilib_src_install_all() {
	insinto /usr/share/ladspa/rdf
	insopts -m0644
	doins *.rdf
}
