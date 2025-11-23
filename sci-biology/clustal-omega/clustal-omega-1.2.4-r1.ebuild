# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools dot-a

DESCRIPTION="Scalable multiple alignment of protein sequences"
HOMEPAGE="http://www.clustal.org/omega/"
SRC_URI="http://www.clustal.org/omega/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="dev-libs/argtable"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e "s:-O3::g" \
		-i configure.ac || die
	default
	eautoreconf
}

src_configure() {
	lto-guarantee-fat
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	strip-lto-bytecode
}
