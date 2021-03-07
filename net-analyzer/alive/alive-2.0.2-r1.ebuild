# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="a periodic ping program"
HOMEPAGE="https://www.gnu.org/software/alive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

COMMON_DEPEND="
	net-misc/iputils
"
DEPEND="
	app-arch/xz-utils
	${COMMON_DEPEND}
"
RDEPEND="
	dev-scheme/guile
	${COMMON_DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P}-ping-test.patch
)

src_prepare() {
	default
	eautoreconf
}
