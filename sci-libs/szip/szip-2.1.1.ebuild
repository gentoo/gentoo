# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Extended-Rice lossless compression algorithm implementation"
HOMEPAGE="https://www.hdfgroup.org/doc_resource/SZIP/"
SRC_URI="https://support.hdfgroup.org/ftp/lib-external/${PN}/${PV}/src/${P}.tar.gz"

LICENSE="szip"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc x86"
IUSE="static-libs"

RDEPEND="!sci-libs/libaec[szip]"
DEPEND=""

DOCS=( RELEASE.txt HISTORY.txt test/example.c )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
