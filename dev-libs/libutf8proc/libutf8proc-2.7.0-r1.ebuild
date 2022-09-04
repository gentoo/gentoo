# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
USE_RUBY="ruby25 ruby26 ruby27"

inherit ruby-single toolchain-funcs

DESCRIPTION="A clean C Library for processing UTF-8 Unicode data"
HOMEPAGE="https://github.com/JuliaStrings/utf8proc"
SRC_URI="https://github.com/JuliaStrings/${PN#lib}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	cjk? ( https://dev.gentoo.org/~hattya/distfiles/${PN}-EastAsianWidth-14.0.0.xz )"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos"
IUSE="cjk static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? (
		=app-i18n/unicode-data-14.0*
		${RUBY_DEPS}
	)"
S="${WORKDIR}/${P#lib}"

QA_PKGCONFIG_VERSION="$(ver_cut 1).5.0"

src_prepare() {
	if use cjk; then
		einfo "Modifying East Asian Ambiguous (A) as wide ..."
		cp "${WORKDIR}"/${PN}-EastAsianWidth-14.0.0 ${PN#lib}_data.c || die
	fi

	default
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		prefix="${EPREFIX}/usr" \
		libdir='$(prefix)'"/$(get_libdir)"
}

src_test() {
	cp "${BROOT}"/usr/share/unicode-data/{DerivedCoreProperties,{Normalization,auxiliary/GraphemeBreak}Test}.txt data || die

	emake CC="$(tc-getCC)" check
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		libdir='$(prefix)'"/$(get_libdir)" \
		install
	use static-libs || find "${ED}" -name '*.a' -delete || die
}
