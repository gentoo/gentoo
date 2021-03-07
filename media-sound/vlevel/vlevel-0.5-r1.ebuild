# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Dynamic compressor to amplify quiet parts of music"
HOMEPAGE="http://vlevel.sourceforge.net/"
SRC_URI="mirror://sourceforge/vlevel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="media-libs/ladspa-sdk"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	emake PREFIX="${ED}"/usr/bin/ LADSPA_PREFIX="${ED}"/usr/$(get_libdir)/ladspa/ install

	dodoc -r README TODO docs/.

	docinto examples
	dodoc utils/{levelplay,raw2wav,vlevel-dir,README}
	docompress -x /usr/share/doc/${PF}/examples
}
