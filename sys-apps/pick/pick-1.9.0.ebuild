# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="a fuzzy search tool for the command-line"
HOMEPAGE="https://github.com/calleerlandsson/pick"
SRC_URI="https://github.com/calleerlandsson/pick/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.0-cflags.patch
)

src_prepare() {
	default
	eautoreconf
}
