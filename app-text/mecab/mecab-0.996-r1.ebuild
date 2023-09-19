# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Yet Another Part-of-Speech and Morphological Analyzer"
HOMEPAGE="https://taku910.github.io/mecab/"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 GPL-2 )"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"
IUSE="static-libs unicode"

BDEPEND="
	dev-lang/perl
	sys-devel/gettext
"
DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"
PDEPEND="
	|| (
		app-dicts/mecab-ipadic[unicode=]
		app-dicts/mecab-naist-jdic[unicode=]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.98-iconv.patch
	"${FILESDIR}"/${PN}-0.996-clang-16-register.patch
)

HTML_DOCS=( doc/. )

src_prepare() {
	default
	sed -i \
		-e "/CFLAGS/s/-O3/${CFLAGS}/" \
		-e "/CXXFLAGS/s/-O3/${CXXFLAGS}/" \
		configure.in
	sed -i "s:/lib:/$(get_libdir):" ${PN}rc.in

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with unicode charset UTF-8)
}

src_install() {
	default
	find "${ED}" -name 'Makefile*' -delete || die
	use static-libs || find "${ED}" -name '*.la' -delete || die
}
