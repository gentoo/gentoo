# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/galib/galib-2.4.7.ebuild,v 1.4 2012/09/05 19:00:51 jlec Exp $

EAPI=4

inherit multilib

MYPV="${PV//\./}"

DESCRIPTION="Library for genetic algorithms in C++ programs"
HOMEPAGE="http://lancet.mit.edu/ga/"
SRC_URI="http://lancet.mit.edu/ga/dist/galib${MYPV}.tgz"

LICENSE="BSD examples? ( GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

S="${WORKDIR}/galib${MYPV}"

src_prepare() {
	sed -i \
		-e 's:/include:${EPREFIX}/usr/include:' \
		-e "s:/lib:${EPREFIX}/usr/$(get_libdir):" \
		-e '/^CXX/d' \
		-e '/^CXXFLAGS/d' \
		-e '/^LD/d' \
		makevars || die "sed makevars failed"
}

src_compile() {
	emake lib
}

src_install() {
	dodir /usr/$(get_libdir)
	default

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		cd examples
		make clean
		sed -i \
			-e '/^include/d' \
			-e '/^INC_DIRS/d' \
			-e '/^LIB_DIRS/d' \
			makefile || die "sed makefile failed"
		doins -r *
	fi
}
