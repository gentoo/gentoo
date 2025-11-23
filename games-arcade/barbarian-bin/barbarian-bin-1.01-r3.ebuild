# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper

MY_PN=${PN/-bin/}
DESCRIPTION="Save Princess Mariana through one-on-one battles with demonic barbarians"
HOMEPAGE="http://www.tdbsoft.com/"
SRC_URI="http://www.pcpages.com/tomberrr/downloads/${MY_PN}${PV/./}_linux.zip"
S="${WORKDIR}"

LICENSE="CC-BY-NC-ND-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip"

RDEPEND="
	acct-group/gamestat
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-)]
	sys-libs/glibc
	sys-libs/libstdc++-v3:5
	amd64? ( sys-libs/libstdc++-v3:5[multilib] )
"
BDEPEND="app-arch/unzip"

game_dest="/opt/${MY_PN}"
QA_PREBUILT="${game_dest#/}/Barbarian"

src_install() {
	dodir ${game_dest}
	cp -r gfx sounds "${ED}"/${game_dest}/ || die

	exeinto ${game_dest}
	doexe Barbarian

	docinto html
	dodoc Barbarian.html

	make_wrapper barbarian ./Barbarian "${game_dest}"

	# High-score file
	dodir /var/games/${PN}
	touch "${ED}"/var/games/${PN}/heroes.hoh || die
	dosym ../../var/games/${PN}/heroes.hoh /opt/${MY_PN}/heroes.hoh

	fperms 660 /var/games/${PN}/heroes.hoh
	fowners -R root:gamestat /var/games/${PN} /opt/${MY_PN}/Barbarian
	fperms g+s /opt/${MY_PN}/Barbarian

	newicon gfx/sprites/player_attack_2_1.bmp barbarian.bmp
	make_desktop_entry barbarian "Barbarian" /usr/share/pixmaps/barbarian.bmp
}
