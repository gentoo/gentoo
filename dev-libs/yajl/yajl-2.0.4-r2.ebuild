# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/yajl/yajl-2.0.4-r2.ebuild,v 1.2 2013/06/26 10:28:11 xmw Exp $

EAPI=5

inherit eutils cmake-multilib vcs-snapshot

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="http://lloyd.github.com/yajl/"
SRC_URI="http://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-fix_static_linking.patch

	multilib_copy_sources
}

src_test() {
	run_test() {
		cd "${BUILD_DIR}"/test
		./run_tests.sh ./yajl_test || die
	}
	multilib_parallel_foreach_abi run_test
}

src_install() {
	cmake-multilib_src_install

	use static-libs || \
		find "${D}" -name libyajl_s.a -delete
}
