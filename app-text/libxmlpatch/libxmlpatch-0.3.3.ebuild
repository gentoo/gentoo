# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A set of tools to create and apply patch to XML files using XPath"
HOMEPAGE="http://xmlpatch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN/lib}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_with test check)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
