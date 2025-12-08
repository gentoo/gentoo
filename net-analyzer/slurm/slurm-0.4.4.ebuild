# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Realtime network interface monitor based on FreeBSD's pppstatus"
HOMEPAGE="https://github.com/mattthias/slurm"
SRC_URI="https://github.com/mattthias/slurm/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-upstream-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

DOCS=( ChangeLog FAQ KEYS README.md THEMES.txt TODO )
