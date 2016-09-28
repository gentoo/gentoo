# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Library for sci-biology/mauve"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-2"
IUSE="doc static-libs"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boost:=
	sci-libs/libgenome
	sci-libs/libmuscle"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-boost.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
	"${FILESDIR}"/${P}-broken-constness.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
