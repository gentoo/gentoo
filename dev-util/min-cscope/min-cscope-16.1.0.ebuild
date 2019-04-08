# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Interactively examine a C program"
HOMEPAGE="https://sourceforge.net/projects/kscope/"
SRC_URI="mirror://sourceforge/kscope/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

S=${WORKDIR}/${PN}

DOCS=( AUTHORS README{,.cscope} TODO )

PATCHES=(
	"${FILESDIR}/${P}-tinfo.patch" #678886
)

src_prepare() {
	cmake-utils_src_prepare

	echo 'INSTALL(TARGETS min-cscope RUNTIME DESTINATION bin)' \
		>> src/CMakeLists.txt || die
}

src_configure() {
	append-flags -I"${S}/sort"
	cmake-utils_src_configure
}
