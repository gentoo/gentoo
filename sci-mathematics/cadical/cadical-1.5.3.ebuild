# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simplified Satisfiability Solver"
HOMEPAGE="http://fmv.jku.at/cadical/"
SRC_URI="https://github.com/arminbiere/${PN}/archive/rel-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-rel-${PV}

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-configure.patch
	"${FILESDIR}"/${PN}-makefile.in-ar.patch
)

DOCS=( BUILD.md CONTRIBUTING NEWS.md README.md VERSION )

src_configure() {
	tc-export AR
	CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} ${LDFLAGS}" ./configure || die
}

src_install() {
	exeinto /usr/bin
	doexe build/{cadical,mobical}
	dolib.a build/libcadical.a
	doheader src/cadical.hpp
	einstalldocs
}
