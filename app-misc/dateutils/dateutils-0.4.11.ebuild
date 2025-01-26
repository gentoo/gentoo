# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command line date and time utilities"
HOMEPAGE="https://www.fresse.org/dateutils/ https://github.com/hroptatyr/dateutils"

case "${PV}" in
	9999)
		inherit autotools git-r3
		EGIT_REPO_URI="https://github.com/hroptatyr/dateutils.git"
		;;
	*)
		SRC_URI="https://github.com/hroptatyr/dateutils/releases/download/v${PV}/${P}.tar.xz"
		KEYWORDS="~amd64 ~x86"
esac

LICENSE="BSD"
SLOT="0"

DEPEND="sys-libs/timezone-data"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	[[ "${PV}" = 9999 ]] && eautoreconf
}

src_configure() {
	econf CFLAGS="${CFLAGS}"
}
