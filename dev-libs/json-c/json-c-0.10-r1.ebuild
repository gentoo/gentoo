# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"
SRC_URI="mirror://github/${PN}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc static-libs"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch

	# bug 452234
	"${FILESDIR}"/${P}-headers.patch
	# bug 466960
	"${FILESDIR}"/${P}-automake-1.13.patch
	)

# tests break otherwise
AUTOTOOLS_IN_SOURCE_BUILD=1

src_test() {
	export USE_VALGRIND=0 VERBOSE=1
	autotools-utils_src_test
}

src_install() {
	use doc && HTML_DOCS=( "${S}"/doc/html )
	autotools-utils_src_install

	# add symlink for projects not using pkgconfig
	dosym ../json-c /usr/include/json-c/json
}
