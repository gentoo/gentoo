# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs multilib multilib-minimal

IUSE=""
MY_P=caps-${PV}

DESCRIPTION="The CAPS Audio Plugin Suite - LADSPA plugin suite"
HOMEPAGE="http://quitte.de/dsp/caps.html"
SRC_URI="http://quitte.de/dsp/caps_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r2
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"

S="${WORKDIR}/${MY_P}"
DOCS=( README CHANGES )

src_prepare() {
	epatch "${FILESDIR}/${P}-double-free-corruption.patch"
	multilib_copy_sources
}

multilib_src_compile() {
	emake CFLAGS="${CXXFLAGS} -fPIC -DPIC" _LDFLAGS="-nostartfiles -shared ${LDFLAGS}" CC="$(tc-getCXX)"
}

multilib_src_install() {
	dohtml caps.html

	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}

multilib_src_install_all() {
	einstalldocs
	insinto /usr/share/ladspa/rdf
	insopts -m0644
	doins *.rdf
}
