# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="$(ver_rs 1-2 -)"

DESCRIPTION="Squid Top - top for Squid"
HOMEPAGE="https://github.com/paleg/sqtop"
SRC_URI="https://github.com/paleg/sqtop/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2015.02.08-ncurses.patch"
)

src_prepare() {
	default
	eautoreconf
}
