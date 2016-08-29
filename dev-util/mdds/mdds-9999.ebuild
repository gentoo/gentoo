# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://gitlab.com/mdds/mdds.git"
[[ ${PV} == 9999 ]] && GITECLASS="git-r3 autotools"

inherit eutils toolchain-funcs ${GITECLASS}

DESCRIPTION="A collection of multi-dimensional data structure and indexing algorithm"
HOMEPAGE="https://gitlab.com/mdds/mdds"
[[ ${PV} == 9999 ]] || SRC_URI="http://kohei.us/files/${PN}/src/${P}.tar.bz2"

LICENSE="MIT"
SLOT="1/${PV%.*}"
IUSE="doc valgrind"

[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		dev-python/sphinx
	)
"

DOCS=() # buildsystem installs docs

src_prepare(){
	eapply_user
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc docs) \
		$(use_enable valgrind memory_tests) \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_compile() { :; }

src_test() {
	tc-export CXX
	default
}
