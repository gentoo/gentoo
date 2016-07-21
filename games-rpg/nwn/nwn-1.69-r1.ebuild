# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

MY_PV=${PV//.}
PATCH_URL_BASE=http://files.bioware.com/neverwinternights/updates/linux/${MY_PV}/English_linuxclient${MY_PV}_

DESCRIPTION="role-playing game set in a huge medieval fantasy world of Dungeons and Dragons"
HOMEPAGE="http://nwn.bioware.com/downloads/linuxclient.html"
SRC_URI="https://dev.gentoo.org/~calchan/distfiles/nwn-libs-1.tar.bz2
	!sou? ( !hou? ( ${PATCH_URL_BASE}orig.tar.gz ) )
	sou? ( !hou? ( ${PATCH_URL_BASE}xp1.tar.gz ) )
	hou? ( ${PATCH_URL_BASE}xp2.tar.gz )"

LICENSE="NWN-EULA"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="sou hou"
RESTRICT="mirror strip"

QA_FLAGS_IGNORED="/opt/nwn/en/nwserver /opt/nwn/en/nwmain /opt/nwn/lib/libSDL-1.2.so.0.11.2 /opt/nwn/lib/libelf.so.1"

NWN_DATA=">=games-rpg/nwn-data-1.29-r3[sou?,hou?"

# ${P} requires games-rpg/nwn-data emerged with at least LINGUAS=en or none at all
RDEPEND="
	|| (
		${NWN_DATA},linguas_en]
		${NWN_DATA},-linguas_fr,-linguas_de,-linguas_es,-linguas_it]
	)
	!<games-rpg/nwmouse-0.1-r1
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r5[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"
DEPEND=""

S=${WORKDIR}/nwn

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	mkdir -p "${S}"/en
	cd "${S}"/en
	unpack ${A}
	mv lib ..
}

src_install() {
	exeinto "${dir}"
	doexe "${FILESDIR}"/fixinstall
	sed -i \
		-e "s:GENTOO_USER:${GAMES_USER}:" \
		-e "s:GENTOO_GROUP:${GAMES_GROUP}:" \
		-e "s:GENTOO_DIR:${GAMES_PREFIX_OPT}:" \
		-e "s:override miles nwm:miles:" \
		-e "s:chitin.key dialog.tlk nwmain:chitin.key:" \
		-e "s:^chmod a-x:#chmod a-x:" \
		"${Ddir}"/fixinstall || die "sed"
	if use hou || use sou
	then
		sed -i \
			-e "s:chitin.key patch.key:chitin.key:" \
			"${Ddir}"/fixinstall || die "sed"
	fi
	fperms ug+x "${dir}"/fixinstall || die "perms"
	mv "${S}"/* "${Ddir}"
	games_make_wrapper nwn ./nwn "${dir}" "${dir}"
	make_desktop_entry nwn "Neverwinter Nights"
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "The included custom libSDL is patched to enable the following key sequences:"
	elog "  * Left-Alt & Enter - Iconify Window"
	elog "  * Right-Alt & Enter - Toggle between FullScreen/Windowed"
	elog "  * Left-Control & G - Disable the mouse grab that keeps the cursor inside the NWN window"
	elog "  * Right-Control & G - Re-enable the mouse grab to keep the cursor inside the NWN window"
	elog
	elog "The NWN linux client is now installed."
	elog "Proceed with the following step in order to get it working:"
	elog "Run ${dir}/fixinstall as root"
	echo
	ewarn "This version supports only english, see http://nwn.bioware.com/support/patch.html"
	ewarn "If you were playing with a different language you may want to backup your ~/.nwn and do:"
	ewarn "    mv  ~/.nwn/<language>  ~/.nwn/en"
	ewarn "If it does not work, try removing ~/.nwn, start nwn then quit, and re-import all you"
	ewarn "need (saves, etc...) in  ~/.nwn/en, but please do not file a bug."
}
