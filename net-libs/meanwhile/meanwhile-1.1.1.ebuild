# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Meanwhile (Sametime protocol) library"
HOMEPAGE="https://meanwhile.sourceforge.net/
	https://github.com/obriencj/meanwhile"
SRC_URI="https://github.com/obriencj/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc debug"

RDEPEND="dev-libs/glib:2"
DEPEND="
	${RDEPEND}
	dev-libs/gmp"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )"

PATCHES=(
	# bug 241298
	"${FILESDIR}"/${PN}-1.0.2-gentoo-fhs-samples.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -fno-tree-vrp

	econf \
		--enable-doxygen=$(usex doc) \
		$(use_enable debug)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
