# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Generic tool for pairwise sequence comparison"
HOMEPAGE="https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate"
SRC_URI="http://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos"
IUSE="test threads utils"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( utils )"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-asneeded.patch )

src_prepare() {
	default
	sed \
		-e 's: -O3 -finline-functions::g' \
		-i configure.in || die
	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	tc-export CC

	econf \
		--enable-glib2 \
		--enable-largefile \
		$(use_enable utils utilities) \
		$(use_enable threads pthreads)
}

src_install() {
	default

	doman doc/man/man1/*.1
}
