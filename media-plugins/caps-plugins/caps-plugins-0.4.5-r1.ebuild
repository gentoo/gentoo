# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/caps-plugins/caps-plugins-0.4.5-r1.ebuild,v 1.3 2013/03/25 20:41:17 ago Exp $

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
