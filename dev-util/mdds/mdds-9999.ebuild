# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://gitlab.com/mdds/mdds.git"
[[ ${PV} == 9999 ]] && GITECLASS="git-r3"

inherit autotools toolchain-funcs ${GITECLASS}

DESCRIPTION="A collection of multi-dimensional data structure and indexing algorithm"
HOMEPAGE="https://gitlab.com/mdds/mdds"
[[ ${PV} == 9999 ]] || SRC_URI="https://kohei.us/files/${PN}/src/${P}.tar.bz2"

LICENSE="MIT"
SLOT="1/${PV%.*}"
IUSE="doc valgrind"

[[ ${PV} == 9999 ]] || \
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen
		dev-python/sphinx
	)
	valgrind? ( dev-util/valgrind )
"

PATCHES=( "${FILESDIR}/${PN}-1.4.1-buildsystem.patch" )

src_prepare(){
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable doc docs) \
		$(use_enable valgrind memory_tests)
}

src_compile() { :; }

src_test() {
	tc-export CXX
	default
}
