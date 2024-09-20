# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit autotools guile-single unpacker

DESCRIPTION="Periodic ping program"
HOMEPAGE="https://www.gnu.org/software/alive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.lz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

REQUIRED_USE="${GUILE_REQUIRED_USE}"

DEPEND="${GUILE_DEPS}"
RDEPEND="${DEPEND}
	dev-scheme/xdgdirs
	net-misc/iputils"
BDEPEND="$(unpacker_src_uri_depends)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.2-ping-test.patch
)

src_prepare() {
	guile-single_src_prepare

	eautoreconf
}
