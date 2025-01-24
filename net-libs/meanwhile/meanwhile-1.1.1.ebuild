# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86"
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
	# bug #935514
	sed -i -e "s|-g -O0 -Weverything||g" configure.ac || die
	eautoreconf
}

src_configure() {
	# https://bugs.debian.org/815045
	# https://bugs.debian.org/940621
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
