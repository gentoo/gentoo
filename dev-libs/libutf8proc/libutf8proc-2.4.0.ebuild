# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="A clean C Library for processing UTF-8 Unicode data"
HOMEPAGE="https://github.com/JuliaStrings/utf8proc"
SRC_URI="https://github.com/JuliaStrings/${PN#lib}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	cjk? ( https://dev.gentoo.org/~hattya/distfiles/${PN}-EastAsianWidth-12.1.0.xz )"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE="cjk static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( =app-i18n/unicode-data-12.0* )"
S="${WORKDIR}/${P#lib}"

PATCHES=( "${FILESDIR}"/${PN}-grapheme-test.patch )

src_prepare() {
	if use cjk; then
		einfo "Modifying East Asian Ambiguous (A) as wide ..."
		cp "${WORKDIR}"/${PN}-EastAsianWidth-12.1.0 ${PN#lib}_data.c || die
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
	# This package used to use netsurf's version as an upstream, which lives in
	# its own little world. Unlike julia's version, it puts its header file
	# in libutf8proc/utf8proc.h instead of utf8proc.h. The problem is that
	# revdeps are *already* patched to ajust to this. As a transitionary
	# measure until we unpatch revdeps, we add a symlink to utf8proc.h.
	dodir /usr/include/libutf8proc
	dosym ../utf8proc.h /usr/include/libutf8proc/utf8proc.h
}

src_test() {
	cp "${EPREFIX}"/usr/share/unicode-data/{Normalization,auxiliary/GraphemeBreak}Test.txt data || die

	emake CC="$(tc-getCC)" check
}
