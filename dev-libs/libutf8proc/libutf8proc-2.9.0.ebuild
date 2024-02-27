# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
USE_RUBY="ruby31 ruby32"

inherit ruby-single toolchain-funcs

DESCRIPTION="A clean C Library for processing UTF-8 Unicode data"
HOMEPAGE="https://github.com/JuliaStrings/utf8proc"
SRC_URI="https://github.com/JuliaStrings/${PN#lib}/releases/download/v${PV}/${P#lib}.tar.gz -> ${P}.tar.gz
	cjk? ( https://dev.gentoo.org/~hattya/distfiles/${PN}-EastAsianWidth-15.1.0.xz )"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="cjk static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? (
		=app-i18n/unicode-data-15.1*
		${RUBY_DEPS}
	)"
S="${WORKDIR}/${P#lib}"

QA_PKGCONFIG_VERSION="3.0.0"

src_prepare() {
	if use cjk; then
		einfo "Modifying East Asian Ambiguous (A) as wide ..."
		cp "${WORKDIR}"/${PN}-EastAsianWidth-15.1.0 ${PN#lib}_data.c || die
	fi

	sed -i "/^libdir/s:/lib:/$(get_libdir):" Makefile
	default
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		prefix="${EPREFIX}/usr"
}

src_test() {
	cp "${BROOT}"/usr/share/unicode-data/{DerivedCoreProperties,{Normalization,auxiliary/GraphemeBreak}Test}.txt data || die

	emake CC="$(tc-getCC)" check
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		install
	use static-libs || find "${ED}" -name '*.a' -delete || die
}
