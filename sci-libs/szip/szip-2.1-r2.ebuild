# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Extended-Rice lossless compression algorithm implementation"
HOMEPAGE="http://www.hdfgroup.org/doc_resource/SZIP/"
SRC_URI="ftp://ftp.hdfgroup.org/lib-external/${PN}/${PV}/src/${P}.tar.gz"

LICENSE="szip"
SLOT="0/2"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="!sci-libs/libaec[szip]"
DEPEND=""

DOCS=( RELEASE.txt HISTORY.txt examples/example.c )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
