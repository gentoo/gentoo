# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="Realtime network interface monitor based on FreeBSD's pppstatus"
HOMEPAGE="https://github.com/mattthias/slurm"
SRC_URI="https://github.com/mattthias/slurm/archive/refs/tags/upstream/${PV}.tar.gz -> ${P}.gh@${GH_TS}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-upstream"

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
