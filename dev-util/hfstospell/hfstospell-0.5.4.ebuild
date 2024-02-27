# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="HFST spell checker library and command line tool"
HOMEPAGE="https://github.com/hfst/hfst-ospell"
SRC_URI="https://github.com/hfst/hfst-ospell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"
IUSE="clang"

DEPEND="app-arch/libarchive:=
	dev-libs/icu:=
	!clang? (
		dev-cpp/glibmm:2
		dev-cpp/libxmlpp:2.6
		dev-libs/glib:2
		dev-libs/libsigc++:2
		dev-libs/libxml2
	)"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/hfst-ospell-${PV}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {

	local myeconfargs=(
		--disable-extra-demos

		--enable-hfst-ospell-office
		--enable-hfst-ospell-predict
		--enable-zhfst
	)

	# https://github.com/hfst/hfst-ospell/issues/48
	if tc-is-clang; then
		myeconfargs+=(
			--without-libxmlpp
			--without-tinyxml2
		)
	elif use clang; then
		myeconfargs+=(
			--without-libxmlpp
			--without-tinyxml2
		)
	else
		myeconfargs+=(
			--with-libxmlpp
			--without-tinyxml2
		)
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete -o -name '*.a' -delete || die
}
