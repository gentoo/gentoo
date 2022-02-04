# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools out-of-source

DESCRIPTION="Library for MS CHM (compressed html) file format"
HOMEPAGE="http://www.jedrea.com/chmlib/"
SRC_URI="http://www.jedrea.com/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv x86"
IUSE="+examples static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-0.39-stdtypes.patch
	"${FILESDIR}"/${P}-headers.patch
)

src_prepare() {
	default
	# Required for CONFIG_SHELL != bash (bug #668408)
	eautoreconf
}

my_src_configure() {
	local myeconfargs=(
		$(use_enable examples)
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

my_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
