# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=fortune-mod-norbert.tretkowski-${PV}
DESCRIPTION="Quotes from Norbert Tretkowski"
HOMEPAGE="https://fortune-mod-fvl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/fortune-mod-fvl/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86"

RDEPEND="games-misc/fortune-mod"

src_install() {
	insinto /usr/share/fortune
	doins norbert.tretkowski norbert.tretkowski.dat
}
