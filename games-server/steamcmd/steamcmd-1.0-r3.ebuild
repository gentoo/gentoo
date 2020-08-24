# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="This is the command-line version of the Steam client for dedicated servers"
HOMEPAGE="https://developer.valvesoftware.com/wiki/SteamCMD"
SRC_URI="https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ Steam"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	acct-group/steamcmd
	acct-user/steamcmd
	app-misc/dtach
"

RESTRICT="bindist mirror"

S="${WORKDIR}"

QA_PREBUILT="
	opt/steamcmd/linux32/libstdc++.so.6
	opt/steamcmd/linux32/steamcmd
"

src_install() {
	diropts -o steamcmd -g steamcmd
	dodir /opt/steamcmd
	keepdir /opt/steamcmd/{.steam,.steam/sdk32,linux32}

	exeopts -o steamcmd -g steamcmd
	exeinto /opt/steamcmd
	doexe steamcmd.sh

	exeopts -o steamcmd -g steamcmd
	exeinto /opt/steamcmd/linux32
	doexe linux32/steamcmd linux32/libstdc++.so.6

	newinitd "${FILESDIR}"/steamcmd.initd-r2 steamcmd
	newconfd "${FILESDIR}"/steamcmd.confd-r2 steamcmd

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
