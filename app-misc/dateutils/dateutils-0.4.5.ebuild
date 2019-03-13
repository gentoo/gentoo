# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="command line date and time utilities"
HOMEPAGE="https://hroptatyr.github.com/dateutils/"
SRC_URI="https://bitbucket.org/hroptatyr/${PN}/downloads/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/xz-utils
	sys-libs/timezone-data"

# bug 429810
RDEPEND="!sys-fabric/dapl"

src_configure() {
	econf --docdir=/usr/share/doc/${PF}
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_test() {
	# parallel tests failure
	emake CFLAGS="${CFLAGS}" -j1 check
}
