# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A quick and light preprocessor, but anyway fully compliant to C99"
HOMEPAGE="https://code.google.com/p/ucpp/"
SRC_URI="http://dev.gentooexperimental.org/~scarabeus/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86 ~amd64-linux"
IUSE="static-libs"

src_configure() {
	econf \
		--disable-werror \
		$(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
