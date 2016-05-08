# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Different date format used upstream.
RE2_VER="${PV:3:4}-${PV:7:2}-${PV:9:2}"

DESCRIPTION="An efficent, principled regular expression library"
HOMEPAGE="https://www.github.com/google/re2/"
SRC_URI="https://www.github.com/google/re2/archive/${RE2_VER}.tar.gz -> ${PN}-${RE2_VER}.tar.gz"
S="${WORKDIR}/${PN}-${RE2_VER}"

LICENSE="BSD"
SLOT="0/0.20160401"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="icu"

PATCHES=( "${FILESDIR}/${PN}-${RE2_VER}-makefile.patch" )
DOCS=( "AUTHORS" "CONTRIBUTORS" "README" "doc/syntax.txt" )
HTML_DOCS=( "doc/syntax.html" )

src_prepare() {
	default

	if use icu; then
		sed -i '7,8 s/# //' Makefile
	fi
}

src_install() {
	emake DESTDIR="${ED}" prefix=usr libdir=usr/$(get_libdir) install
	rm "${ED}/usr/$(get_libdir)/libre2.a" || die

	einstalldocs
}
