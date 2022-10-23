# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Interactively examine a C program"
HOMEPAGE="https://sourceforge.net/projects/kscope/"
SRC_URI="mirror://sourceforge/kscope/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README{,.cscope} TODO )

PATCHES=(
	"${FILESDIR}/${P}-tinfo.patch" # bug #678886
	"${FILESDIR}/${P}-pointer-type.patch"
)

src_prepare() {
	cmake_src_prepare

	echo 'INSTALL(TARGETS min-cscope RUNTIME DESTINATION bin)' \
		>> src/CMakeLists.txt || die
}

src_configure() {
	# -D_GNU_SOURCE for qsort_r, bug #871162
	append-cppflags -I"${S}"/sort -D_GNU_SOURCE

	cmake_src_configure
}
