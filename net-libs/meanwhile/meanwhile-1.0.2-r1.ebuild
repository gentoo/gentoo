# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Meanwhile (Sametime protocol) library"
HOMEPAGE="http://meanwhile.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="doc debug"

RDEPEND="dev-libs/glib:2"
DEPEND="
	${RDEPEND}
	dev-libs/gmp"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	# bug 239144
	"${FILESDIR}"/${P}-presence.patch
	# bug 409081
	"${FILESDIR}"/${P}-glib2.31.patch
	# bug 241298
	"${FILESDIR}"/${P}-gentoo-fhs-samples.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -fno-tree-vrp

	econf \
		--disable-static \
		--enable-doxygen=$(usex doc) \
		$(use_enable debug)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
