# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simplified Satisfiability Solver"
HOMEPAGE="http://fmv.jku.at/cadical/
	https://github.com/arminbiere/cadical/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/arminbiere/${PN}.git"
else
	SRC_URI="https://github.com/arminbiere/${PN}/archive/rel-${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-rel-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-configure.patch"
	"${FILESDIR}/${PN}-makefile-in-respect-ar-2.0.0.patch"
)

DOCS=( CONTRIBUTING.md NEWS.md README.md )

src_configure() {
	tc-export AR

	CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} ${LDFLAGS}" ./configure || die
}

src_install() {
	exeinto /usr/bin
	doexe build/{cadical,mobical}

	dolib.a build/libcadical.a
	doheader src/cadical.hpp
	doheader src/ccadical.h

	einstalldocs
}
