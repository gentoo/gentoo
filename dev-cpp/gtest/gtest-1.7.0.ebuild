# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtest/gtest-1.7.0.ebuild,v 1.9 2015/04/21 19:04:11 pacho Exp $

EAPI="5"

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
# Python is required for tests and some build tasks.
PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 autotools-multilib

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="http://code.google.com/p/googletest/"
SRC_URI="http://googletest.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="examples static-libs"

DEPEND="app-arch/unzip
	${PYTHON_DEPS}"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/configure-fix-pthread-linking.patch" #371647
)

src_prepare() {
	sed -i -e "s|/tmp|${T}|g" test/gtest-filepath_test.cc || die
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.am || die
	autotools-multilib_src_prepare
}

multilib_src_install() {
	default
	multilib_is_native_abi && dobin scripts/gtest-config
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*.{cc,h}
	fi
}
