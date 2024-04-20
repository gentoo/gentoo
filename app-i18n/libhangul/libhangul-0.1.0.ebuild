# Copyright 2006-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit libtool

DESCRIPTION="Library for hangul input method logic, hanja dictionary"
HOMEPAGE="https://github.com/libhangul/libhangul"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="amd64 ~arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="nls static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="virtual/libiconv
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

src_prepare() {
	default
	elibtoolize
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_test() {
	emake -C test check
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
