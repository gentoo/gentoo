# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A bunch of LADSPA plugins for audio processing"
HOMEPAGE="http://tap-plugins.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.7.3-cflags-ldflags.patch )

src_compile() {
	emake CC=$(tc-getCC) OPT_CFLAGS="${CFLAGS}" EXTRA_LDFLAGS="${LDFLAGS}"
}

src_install() {
	einstalldocs

	exeinto /usr/$(get_libdir)/ladspa
	doexe *.so

	insinto /usr/share/ladspa/rdf
	doins *.rdf
}
