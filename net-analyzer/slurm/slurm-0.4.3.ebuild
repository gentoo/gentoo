# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Realtime network interface monitor based on FreeBSD's pppstatus"
HOMEPAGE="https://github.com/mattthias/slurm"
SRC_URI="https://github.com/mattthias/slurm/archive/upstream/${PN}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-upstream"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.3-overflow.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-version.patch
	"${FILESDIR}"/${P}-fix-includes.patch
)

src_install() {
	cmake_src_install
	dodoc KEYS THEMES.txt
}
