# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library for preprocessing C compliant to ISO-C99"
HOMEPAGE="https://gitlab.com/scarabeusiv/ucpp"
SRC_URI="https://gitlab.com/scarabeusiv/${PN}/uploads/79f08e39c676f15ed8a59335f6c9b924/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ~ppc64 x86 ~amd64-linux"

src_configure() {
	econf \
		--disable-werror \
		--disable-static
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -type f -delete || die
}
