# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal ltprune

DESCRIPTION="A JSON implementation in C"
HOMEPAGE="https://github.com/json-c/json-c/wiki"
SRC_URI="https://s3.amazonaws.com/json-c_releases/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc static-libs"

src_prepare() {
	default
	sed -i -e "s:-Werror::" configure.ac || die
	eautoreconf

	# tests break otherwise
	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf $(use_enable static-libs static)
}

multilib_src_test() {
	export USE_VALGRIND=0 VERBOSE=1
	default
}

multilib_src_install_all() {
	use doc && HTML_DOCS=( "${S}"/doc/html/. )
	einstalldocs

	# add symlink for projects not using pkgconfig
	dosym ../json-c /usr/include/json-c/json

	prune_libtool_files
}
