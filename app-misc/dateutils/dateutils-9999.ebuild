# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="command line date and time utilities"
HOMEPAGE="https://www.fresse.org/dateutils/ https://github.com/hroptatyr/dateutils"

case "${PV}" in
	9999)
		inherit git-r3 autotools
		EGIT_REPO_URI="https://github.com/hroptatyr/dateutils.git"
		;;
	*)
		SRC_URI="https://bitbucket.org/hroptatyr/dateutils/downloads/${P}.tar.xz"
		KEYWORDS="~amd64 ~x86"
esac

LICENSE="BSD"
SLOT="0"

DEPEND="app-arch/xz-utils
	sys-libs/timezone-data"

# bug 429810
RDEPEND="!sys-fabric/dapl"

src_configure() {
	[[ "${PV}" = 9999 ]] && eautoreconf
	econf CFLAGS="${CFLAGS}"
}
