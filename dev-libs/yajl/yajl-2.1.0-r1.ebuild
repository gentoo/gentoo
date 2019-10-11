# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib vcs-snapshot

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="https://lloyd.github.com/yajl/"
SRC_URI="https://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0/2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

PATCHES=( "${FILESDIR}"/${P}-uclibc.patch )

src_prepare() {
	cmake-utils_src_prepare

	multilib_copy_sources
}

src_test() {
	run_test() {
		cd "${BUILD_DIR}"/test/parsing
		./run_tests.sh ./yajl_test || die
	}
	multilib_parallel_foreach_abi run_test
}

src_install() {
	cmake-multilib_src_install

	use static-libs || \
		find "${D}" -name libyajl_s.a -delete
}
