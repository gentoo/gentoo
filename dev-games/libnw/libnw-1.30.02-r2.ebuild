# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Tools and libraries for NWN file manipulation"
HOMEPAGE="https://sourceforge.net/projects/openknights/"
SRC_URI="https://downloads.sourceforge.net/openknights/${P}.tar.gz"

LICENSE="openknights"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="!sci-biology/newick-utils"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex"

DOCS=( AUTHORS ChangeLog NEWS README README.tech TODO )

PATCHES=( "${FILESDIR}/${P}-C23.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/855314
	#
	# Sourceforge software dead since 2006, no point reporting anything.
	append-flags -fno-strict-aliasing
	filter-lto

	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
