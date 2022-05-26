# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GNU Astronomy Utilities"
HOMEPAGE="https://www.gnu.org/software/gnuastro"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="static-libs threads"

# jpeg, pdf, and libgit2 are forced deps
# because they are automagically detected.

RDEPEND="
	app-text/ghostscript-gpl
	dev-libs/libgit2:=
	media-libs/tiff
	net-misc/curl
	sci-astronomy/wcslib:0=
	sci-libs/cfitsio:0=
	sci-libs/gsl:0=
	sys-libs/zlib:=
	virtual/jpeg:0=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e 's/-O3//' configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable threads)
	)
	econf ${myeconfargs[@]}
}

src_install() {
	default

	if ! use static-libs; then
		find "${ED}" -name '*.la' -delete || die
	fi
}
