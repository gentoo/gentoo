# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://gitlab.com/mdds/mdds.git"
[[ ${PV} == 9999 ]] && GITECLASS="git-r3"

inherit autotools toolchain-funcs ${GITECLASS}

DESCRIPTION="A collection of multi-dimensional data structure and indexing algorithm"
HOMEPAGE="https://gitlab.com/mdds/mdds"
[[ ${PV} == 9999 ]] || SRC_URI="https://kohei.us/files/${PN}/src/${P}.tar.bz2"

LICENSE="MIT"
SLOT="1/1.2"
IUSE="valgrind"

[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
"

PATCHES=( "${FILESDIR}/${PN}-1.2.3-buildsystem.patch" )

src_prepare(){
	default
	eautoreconf
}

src_configure() {
	# docs require dev-python/breathe etc., bug #602026
	econf \
		--disable-docs \
		$(use_enable valgrind memory_tests)
}

src_compile() { :; }

src_test() {
	tc-export CXX
	default
}
