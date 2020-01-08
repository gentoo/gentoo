# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-multilib

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"
SRC_URI="https://s3.amazonaws.com/json-c_releases/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc static-libs"

RDEPEND=""

# tests break otherwise
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	sed -i -e "s:-Werror::" Makefile.am.inc || die
	autotools-multilib_src_prepare
}

src_test() {
	export USE_VALGRIND=0 VERBOSE=1
	autotools-multilib_src_test
}

src_install() {
	use doc && HTML_DOCS=( "${S}"/doc/html )
	autotools-multilib_src_install

	# add symlink for projects not using pkgconfig
	dosym ../json-c /usr/include/json-c/json
}
