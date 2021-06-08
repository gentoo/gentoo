# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A periodic ping program"
HOMEPAGE="https://www.gnu.org/software/alive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

BDEPEND="app-arch/xz-utils"
DEPEND="
	dev-scheme/guile
"
RDEPEND="
	${DEPEND}
	dev-scheme/xdgdirs
	net-misc/iputils
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.2-ping-test.patch
)

src_prepare() {
	default
	eautoreconf
}
