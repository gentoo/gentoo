# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-server/ut2003-ded/ut2003-ded-2225-r2.ebuild,v 1.13 2015/03/27 22:06:56 mr_bones_ Exp $

EAPI=5
inherit games

DESCRIPTION="Unreal Tournament 2003 Linux Dedicated Server"
HOMEPAGE="http://www.ut2003.com/"
SRC_URI="http://ftp.games.skynet.be/pub/misc/ut2003-lnxded-${PV}.tar.bz2
	mirror://gentoo/UT2003CrashFix.zip"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror strip"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

QA_PREBUILT="${dir:1}/System/*"

src_unpack() {
	unpack ut2003-lnxded-${PV}.tar.bz2
	unzip "${DISTDIR}"/UT2003CrashFix.zip || die
}

src_install() {
	einfo "This will take a while ... go get a pizza or something"

	dodir "${dir}"
	mv "${S}"/ut2003_dedicated/* "${Ddir}"

	# Here we apply DrSiN's crash patch
	cp "${S}"/CrashFix/System/crashfix.u "${Ddir}"/System

	ed "${Ddir}"/System/Default.ini >/dev/null 2>&1 <<EOT
$
?Engine.GameInfo?
a
AccessControlClass=crashfix.iaccesscontrolini
.
w
q
EOT

	# Here we apply fix for bug #54726
	sed -i \
		-e "s:UplinkToGamespy=True:UplinkToGamespy=False:" \
		"${D}${dir}"/System/Default.ini || die

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "NOTE: To have your server authenticate properly, you"
	ewarn "      MUST visit the following site and request a key."
	ewarn "http://ut2003.epicgames.com/ut2003server/cdkey.php"
	echo
	ewarn "If you are not installing for the first time and you plan on running"
	ewarn "a server, you will probably need to edit your"
	ewarn "~/.ut2003/System/UT2003.ini file and add a line that says"
	ewarn "AccessControlClass=crashfix.iaccesscontrolini to your"
	ewarn "[Engine.GameInfo] section to close a security issue."
}
