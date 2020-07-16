# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="command line date and time utilities"
HOMEPAGE="https://www.fresse.org/dateutils/"
SRC_URI="https://bitbucket.org/hroptatyr/${PN}/downloads/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/xz-utils
	sys-libs/timezone-data"

# bug 429810
RDEPEND="!sys-fabric/dapl"

PATCHES=( "${FILESDIR}"/${P}-unportable-sys-sysctl_h.patch )

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_test() {
	# parallel tests failure
	emake CFLAGS="${CFLAGS}" -j1 check
}
