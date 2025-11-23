# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Platform game inspired by games like Manic Miner and Jet Set Willy"
HOMEPAGE="https://dragontech.sourceforge.net/index.php?main=pachi&lang=en"
# Upstream doesn't version their releases.
# (should be downloaded and re-compressed with tar -jcvf)
#SRC_URI="https://downloads.sourceforge.net/dragontech/pachi_source.tgz"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}"/Pachi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-mixer[mod]
"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	"${FILESDIR}"/${PV}-autotools.patch
)

src_prepare() {
	default

	rm -f missing || die
	mv configure.in configure.ac || die

	sed -i -e 's/games/gamestat/g' data/Makefile.am || die

	eautoreconf
}

src_install() {
	default

	newicon Tgfx/icon.bmp ${PN}.bmp
	make_desktop_entry ${PN} Pachi /usr/share/pixmaps/${PN}.bmp

	fowners root:gamestat /var/lib/${PN}/data/scores.dat /usr/bin/${PN}
	fperms 660 /var/lib/${PN}/data/scores.dat
	fperms g+s /usr/bin/${PN}
}
