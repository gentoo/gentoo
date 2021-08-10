# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tools and libraries for NWN file manipulation"
HOMEPAGE="http://openknights.sourceforge.net/"
SRC_URI="mirror://sourceforge/openknights/${P}.tar.gz"

LICENSE="openknights"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!sci-biology/newick-utils"
BDEPEND="
	sys-devel/bison
	sys-devel/flex"

DOCS=( AUTHORS ChangeLog NEWS README README.tech TODO )

src_prepare() {
	default

	local f
	while IFS="" read -d $'\0' -r f; do
		einfo "Removing hardcoded CC/CXX from ${f}"
		sed -i \
			-e '/^CC =/d' \
			-e '/^CXX =/d' \
			"${f}" || die
	done < <(find "${S}" -name Makefile.in -type f -print0)
}

src_configure() {
	tc-export CC CXX
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
