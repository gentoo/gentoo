# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="Library for accessing a CDDB server"
HOMEPAGE="https://libcddb.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-text/doxygen )"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

MULTILIB_WRAPPED_HEADERS=( /usr/include/cddb/version.h )

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.2-c99.patch
)

src_prepare() {
	default
	# Required for CONFIG_SHELL != bash (bug #528012)
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--without-cdio
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default

	if use doc ; then
		cd "${S}"/doc || die
		doxygen doxygen.conf || die
	fi
}

multilib_src_install_all() {
	default

	find "${ED}" -type f -name "*.la" -delete || die

	if use doc ; then
		docinto html
		dodoc "${S}"/doc/html/*
	fi
}
