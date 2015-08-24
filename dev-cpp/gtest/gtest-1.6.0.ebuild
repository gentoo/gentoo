# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
PYTHON_DEPEND="2"

inherit python libtool

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://code.google.com/p/googletest/"
SRC_URI="https://googletest.googlecode.com/files/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~ppc-macos"
IUSE="examples threads static-libs"

DEPEND="app-arch/unzip"
RDEPEND=""

pkg_setup() {
	python_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	sed -i -e "s|/tmp|${T}|g" test/gtest-filepath_test.cc || die
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.in
	elibtoolize

	python_convert_shebangs -r 2 .
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with threads pthreads)
}

src_test() {
	# explicitly use parallel make
	emake check || die
}

src_install() {
	default
	dobin scripts/gtest-config

	if ! use static-libs ; then
		rm "${ED}"/usr/lib*/*.la || die
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*.{cc,h}
	fi
}
