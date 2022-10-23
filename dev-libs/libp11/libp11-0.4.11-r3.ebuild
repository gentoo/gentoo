# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Abstraction layer to simplify PKCS#11 API"
HOMEPAGE="https://github.com/opensc/libp11/wiki"
SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc static-libs"

RDEPEND="dev-libs/openssl:=[bindist(+)]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable doc api-doc)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
