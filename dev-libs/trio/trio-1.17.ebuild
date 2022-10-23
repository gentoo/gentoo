# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"

inherit autotools docs

DESCRIPTION="Portable string functions, focus on the *printf() and *scanf() clones"
HOMEPAGE="https://daniel.haxx.se/projects/trio/"
SRC_URI="https://github.com/orbea/trio/releases/download/v${PV}/${P}.tar.gz"

LICENSE="trio"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	# Required to fix -Werror=strict-prototypes configure errors
	eautoreconf
}

src_compile() {
	default
	docs_compile
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
