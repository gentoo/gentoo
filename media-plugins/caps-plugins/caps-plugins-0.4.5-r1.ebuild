# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs multilib

IUSE=""
MY_P=caps-${PV}

DESCRIPTION="The CAPS Audio Plugin Suite - LADSPA plugin suite"
HOMEPAGE="http://quitte.de/dsp/caps.html"
SRC_URI="http://quitte.de/dsp/caps_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-double-free-corruption.patch"
}

src_compile() {
	emake CFLAGS="${CXXFLAGS} -fPIC -DPIC" _LDFLAGS="-nostartfiles -shared ${LDFLAGS}" CC="$(tc-getCXX)" || die
}

src_install() {
	dodoc README CHANGES
	dohtml caps.html

	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so

	insinto /usr/share/ladspa/rdf
	insopts -m0644
	doins *.rdf
}
