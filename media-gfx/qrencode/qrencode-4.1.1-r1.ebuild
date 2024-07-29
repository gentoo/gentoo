# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="C library for encoding data in a QR Code symbol"
HOMEPAGE="https://fukuchi.org/works/qrencode/"
SRC_URI="https://fukuchi.org/works/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0/4"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"
IUSE="png test"
RESTRICT="!test? ( test )"

RDEPEND="png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local myconf=(
		$(multilib_native_with tools)
		$(use_with png)
		$(use_with test tests)
		# TODO: figure out how to make SDL check fail as the SDL test
		# program is not useful
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_test() {
	cp "${S}"/tests/test_basic.sh "${BUILD_DIR}"/tests || die
	cd tests || die
	./test_basic.sh || die
}

multilib_src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
