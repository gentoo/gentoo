# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop user

DESCRIPTION="2D MMORPG about mining resources, building castles and destroying your enemies"
HOMEPAGE="https://www.kag2d.com/en/"
KEYWORDS="~amd64"
LICENSE="EULA"
SLOT="0"
SRC_URI="http://dl.kag2d.com/kag-linux32-client-release.tar.gz -> ${P}.tgz"
S="${WORKDIR}"
QA_PREBUILT="
	opt/kag/libJuxta.so
	opt/kag/KAG
	opt/kag/lib/libIrrKlang.so
	opt/kag/lib/libpng15.so
	opt/kag/lib/libsteam_api.so"
KAG_DIR="/opt/${PN}"

pkg_setup() {
	enewgroup games
}

src_prepare() {
	default
	local FILE
	for FILE in *.sh; do
	sed -i -e 's/"\$(dirname \$0)"/\/opt\/kag/' "${FILE}"
	done
}

src_install()
{
	insinto "${KAG_DIR}"
	exeinto "${KAG_DIR}"
	doins -r {App,Base,Docs,lib,Manual,Mods,Security}
	fowners -R root:games "${KAG_DIR}"
	fperms -R 0775 "${KAG_DIR}"
	doins "autoupdate_ignore_custom.cfg"
	doins "autoupdate_ignore.cfg"
	doins "curl-ca-bundle.crt"
	doins "curl-license.txt"
	doins "forceupdate.sh"
	doins "irrlicht.ico"
	doexe "KAG"
	doins "libJuxta.so"
	doins "mods.cfg"
	doexe "nolauncher.sh"
	doins "readme.txt"
	doexe "rungame.sh"
	doexe "runlocalhost.sh"
	doins "steam_appid.txt"
	doins "terms.txt"
	dosym "${ED%/}/opt/kag/rungame.sh" "/usr/bin/kag"
	make_desktop_entry "kag" "KAG" "/opt/kag/irrlicht.ico" "Game"
}

pkg_postinst() {
	elog "Info: For run KAG, you must be in games group"
}
