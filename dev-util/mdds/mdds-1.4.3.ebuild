# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/mdds/mdds.git"
	inherit git-r3
else
	SRC_URI="https://kohei.us/files/${PN}/src/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
fi
inherit autotools toolchain-funcs

DESCRIPTION="A collection of multi-dimensional data structure and indexing algorithm"
HOMEPAGE="https://gitlab.com/mdds/mdds"

LICENSE="MIT"
SLOT="1/${PV%.*}"
IUSE="doc valgrind"

BDEPEND="
	doc? (
		app-doc/doxygen
		dev-python/sphinx
	)
	valgrind? ( dev-util/valgrind )
"
DEPEND="dev-libs/boost:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-buildsystem.patch" )

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
