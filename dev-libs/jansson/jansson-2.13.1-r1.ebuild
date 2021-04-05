# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="C library for encoding, decoding and manipulating JSON data"
HOMEPAGE="https://www.digip.org/jansson/"
SRC_URI="https://www.digip.org/jansson/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="doc static-libs"

BDEPEND="doc? ( dev-python/sphinx )"

PATCHES=(
	# dev-libs/jansson-2.13.1[doc]: fails to build with >=sphinx-3.0, #731668
	"${FILESDIR}/${P}-sphinx3.patch"
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use doc ; then
		emake html
		HTML_DOCS=( "${BUILD_DIR}"/doc/_build/html/. )
	fi
}

multilib_src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
