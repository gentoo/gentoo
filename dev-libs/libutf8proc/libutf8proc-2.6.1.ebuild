# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
USE_RUBY="ruby25 ruby26 ruby27"

inherit ruby-single toolchain-funcs

DESCRIPTION="A clean C Library for processing UTF-8 Unicode data"
HOMEPAGE="https://github.com/JuliaStrings/utf8proc"
SRC_URI="https://github.com/JuliaStrings/${PN#lib}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	cjk? ( https://dev.gentoo.org/~hattya/distfiles/${PN}-EastAsianWidth-13.0.0-r1.xz )"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE="cjk static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? (
		=app-i18n/unicode-data-13.0*
		${RUBY_DEPS}
	)"
S="${WORKDIR}/${P#lib}"

src_prepare() {
	if use cjk; then
		einfo "Modifying East Asian Ambiguous (A) as wide ..."
		cp "${WORKDIR}"/${PN}-EastAsianWidth-13.0.0-r1 ${PN#lib}_data.c || die
	fi

	default
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)"
}

src_install() {
	emake \
		DESTDIR="${ED}" \
		prefix="/usr" \
		libdir="/usr/$(get_libdir)" \
		install
	use static-libs || find "${ED}" -name '*.a' -delete || die
}

src_test() {
	cp "${EPREFIX}"/usr/share/unicode-data/{DerivedCoreProperties,{Normalization,auxiliary/GraphemeBreak}Test}.txt data || die

	emake CC="$(tc-getCC)" check
}
