# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P#lib}"
DESCRIPTION="mapping tool for UTF-8 strings"
HOMEPAGE="https://github.com/JuliaStrings/utf8proc"
SRC_URI="https://github.com/JuliaStrings/utf8proc/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_P}"

BDEPEND="test? ( =app-i18n/unicode-data-12.0* )"

PATCHES=(
	# Don't build or install static libs
	"${FILESDIR}/${PN}-2.3.0-no-static.patch"
	# use app-i18n/unicode-data for test data instead of curl
	"${FILESDIR}/${PN}-2.3.0-tests-nofetch.patch"
)

_emake() {
	emake CC=$(tc-getCC) AR=$(tc-getAR) "$@"
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		install
	# This package used to use netsurf's version as an upstream, which lives in
	# its own little world. Unlike julia's version, it puts its header file
	# in libutf8proc/utf8proc.h instead of utf8proc.h. The problem is that
	# revdeps are *already* patched to ajust to this. As a transitionary
	# measure until we unpatch revdeps, we add a symlink to utf8proc.h.
	dodir /usr/include/libutf8proc
	dosym ../utf8proc.h /usr/include/libutf8proc/utf8proc.h
}

src_test() {
	_emake check
}
