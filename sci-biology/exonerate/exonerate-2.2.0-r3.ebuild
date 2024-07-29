# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Generic tool for pairwise sequence comparison"
HOMEPAGE="https://www.ebi.ac.uk/about/vertebrate-genomics/software/exonerate"
SRC_URI="https://ftp.ebi.ac.uk/pub/software/vertebrategenomics/exonerate/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos"
IUSE="test utils"
REQUIRED_USE="test? ( utils )"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-autotools.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862264
	# Upstream doesn't use a bug tracker, so I fired them an email about it. -- Eli
	filter-lto

	# the bootstrapping code loads AR and CC from the environment
	tc-export CC RANLIB
	export C4_AR="$(tc-getAR)"

	econf \
		--enable-glib2 \
		--enable-largefile \
		--enable-pthreads \
		$(use_enable utils utilities)
}

src_install() {
	default

	doman doc/man/man1/*.1
}
