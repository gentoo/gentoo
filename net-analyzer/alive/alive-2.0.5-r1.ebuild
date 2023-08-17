# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools unpacker

DESCRIPTION="Periodic ping program"
HOMEPAGE="https://www.gnu.org/software/alive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.lz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

DEPEND="dev-scheme/guile"
RDEPEND="${DEPEND}
	dev-scheme/xdgdirs
	net-misc/iputils"
BDEPEND="$(unpacker_src_uri_depends)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.2-ping-test.patch
)

src_prepare() {
	default

	eautoreconf
}
