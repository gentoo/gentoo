# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/jsoncpp/jsoncpp-0.5.0-r1.ebuild,v 1.4 2013/11/17 23:42:25 phajdan.jr Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit multilib toolchain-funcs python-any-r1

MY_P="${PN}-src-${PV}"

DESCRIPTION="C++ JSON reader and writer"
HOMEPAGE="http://jsoncpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="public-domain"

SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="doc"

DEPEND="
	doc? (
		app-doc/doxygen
		${PYTHON_DEPS}
	)"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

cxx_wrapper() {
	set -- $(tc-getCXX) ${CXXFLAGS} ${LDFLAGS} "$@"
	echo "$@"
	"$@"
}

src_compile() {
	soname=libjsoncpp.so.${PV}
	cxx_wrapper src/lib_json/*.cpp -Iinclude -shared -fPIC \
		-Wl,-soname,${soname} -o ${soname} || die
}

src_install() {
	# Follow Debian, Ubuntu, Arch convention for headers location, bug #452234 .
	insinto /usr/include/jsoncpp
	doins -r include/json

	dolib ${soname}
	dosym ${soname} /usr/$(get_libdir)/libjsoncpp.so

	if use doc; then
		${EPYTHON} doxybuild.py --doxygen=/usr/bin/doxygen || die
		dohtml dist/doxygen/jsoncpp*/*
	fi
}
