# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils unpacker games

DESCRIPTION="Anglo-Saxon medieval army battles and resource management"
HOMEPAGE="http://www.linuxgamepublishing.com/info.php?id=knights"
# Unversioned upstream filename
SRC_URI="mirror://gentoo/${P}.run"

LICENSE="knights-demo"
SLOT="0"
KEYWORDS="x86"
IUSE=""
RESTRICT="strip"

RDEPEND="sys-libs/glibc
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXau-1.0.7-r1[abi_x86_32(-)]
	>=x11-libs/libXdmcp-1.1.1-r1[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
	>=x11-libs/libXi-1.7.2[abi_x86_32(-)]"

S=${WORKDIR}

src_unpack() {
	unpack_makeself ${P}.run
	mv -f data{,-temp}
	unpack ./data-temp/data.tar.gz
	rm -rf data-temp lgp_* setup*
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	exeinto "${dir}"
	doexe bin/Linux/x86/${PN}{,.dynamic}

	insinto "${dir}"
	doins -r data
	doins EULA icon.xpm README{,.licenses}

	# We don't support the dynamic version, even though we install it.
	games_make_wrapper ${PN} ./${PN} "${dir}" "${dir}"
	newicon icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Knights and Merchants (Demo)" ${PN}
	prepgamesdirs
}
