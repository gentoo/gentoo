# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

LANGUAGES="linguas_fr linguas_it linguas_es linguas_de linguas_en"

MY_PV=${PV//.}
PATCH_URL_BASE=http://files.bioware.com/neverwinternights/updates/linux/${MY_PV}
PACKAGE_NAME=_linuxclient${MY_PV}_orig.tar.gz
SOU_NAME=_linuxclient${MY_PV}_xp1.tar.gz
HOU_NAME=_linuxclient${MY_PV}_xp2.tar.gz

DESCRIPTION="Epic role-playing game set in a huge medieval fantasy world of Dungeons and Dragons"
HOMEPAGE="http://nwn.bioware.com/downloads/linuxclient.html"
SRC_URI="http://dev.gentoo.org/~calchan/distfiles/nwn-libs-1.tar.bz2
	linguas_fr? (
		!sou? ( !hou? ( ${PATCH_URL_BASE}/French${PACKAGE_NAME} ) )
		sou? ( ${PATCH_URL_BASE}/French${SOU_NAME} )
		hou? ( ${PATCH_URL_BASE}/French${HOU_NAME} ) )
	linguas_it? (
		!sou? ( !hou? ( ${PATCH_URL_BASE}/Italian${PACKAGE_NAME} ) )
		sou? ( ${PATCH_URL_BASE}/Italian${SOU_NAME} )
		hou? ( ${PATCH_URL_BASE}/Italian${HOU_NAME} ) )
	linguas_en? (
		!sou? ( !hou? ( ${PATCH_URL_BASE}/English${PACKAGE_NAME} ) )
		sou? ( ${PATCH_URL_BASE}/English${SOU_NAME} )
		hou? ( ${PATCH_URL_BASE}/English${HOU_NAME} ) )
	linguas_es? (
		!sou? ( !hou? ( ${PATCH_URL_BASE}/Spanish${PACKAGE_NAME} ) )
		sou? ( ${PATCH_URL_BASE}/Spanish${SOU_NAME} )
		hou? ( ${PATCH_URL_BASE}/Spanish${HOU_NAME} ) )
	linguas_de? (
		!sou? ( !hou? ( ${PATCH_URL_BASE}/German${PACKAGE_NAME} ) )
		sou? ( ${PATCH_URL_BASE}/German${SOU_NAME} )
		hou? ( ${PATCH_URL_BASE}/German${HOU_NAME} ) )
	!linguas_en? (
		!linguas_es? (
			!linguas_de? (
				!linguas_fr? (
					!linguas_it? (
		!sou? ( !hou? ( ${PATCH_URL_BASE}/English${PACKAGE_NAME} ) )
		sou? ( ${PATCH_URL_BASE}/English${SOU_NAME} )
		hou? ( ${PATCH_URL_BASE}/English${HOU_NAME} ) ) ) ) ) )"

LICENSE="NWN-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="sou hou ${LANGUAGES}"
RESTRICT="mirror strip"

RDEPEND="
	>=games-rpg/nwn-data-1.29-r3
	!<games-rpg/nwmouse-0.1-r1
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r5[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
"
DEPEND="app-arch/unzip"

S=${WORKDIR}/nwn

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

die_from_busted_nwn-data() {
	local use=$*
	ewarn "You must emerge games-rpg/nwn-data with USE=$use.  You can fix this"
	ewarn "by doing the following:"
	echo
	elog "mkdir -p /etc/portage"
	elog "echo 'games-rpg/nwn-data $use' >> /etc/portage/package.use"
	elog "emerge --oneshot games-rpg/nwn-data"
	die "nwn-data requires USE=$use"
}

pkg_setup() {
	games_pkg_setup
	if use sou
	then
		has_version "games-rpg/nwn-data[sou]" || die_from_busted_nwn-data sou
	fi
	if use hou
	then
		has_version "games-rpg/nwn-data[hou]" || die_from_busted_nwn-data hou
	fi

	strip-linguas de en es fr it
}

src_unpack() {
	mkdir -p "${S}"
	cd "${S}"
	mkdir -p .metadata
	for a in ${A}
	do
		if [ -z "${a/*libs*}" ]
		then
			unpack "${a}"
		fi

		if [ -z "${a/*orig*}" ]
		then
			currentlocale=""
			if [ -z "${a/*German*/}" ]
			then
				currentlocale=de
			elif [ -z "${a/*English*/}" ]
			then
				currentlocale=en
			elif [ -z "${a/*Spanish*/}" ]
			then
				currentlocale=es
			elif [ -z "${a/*Italian*/}" ]
			then
				currentlocale=it
			elif [ -z "${a/*French*/}" ]
			then
				currentlocale=fr
			fi
			if [ -n "$currentlocale" ]
			then
				mkdir -p "${currentlocale}"
				cd "${currentlocale}"
				unpack "${a}"
				cd ..
			fi
		fi
	done
	use sou && (
	for a in ${A}
	do
		if [ -z "${a/*$SOU_NAME}" ]
		then
			currentlocale=""
			if [ -z "${a/*German*/}" ]
			then
				currentlocale=de
			elif [ -z "${a/*English*/}" ]
			then
				currentlocale=en
			elif [ -z "${a/*Spanish*/}" ]
			then
				currentlocale=es
			elif [ -z "${a/*Italian*/}" ]
			then
				currentlocale=it
			elif [ -z "${a/*French*/}" ]
			then
				currentlocale=fr
			fi
			if [ -n "$currentlocale" ]
			then
				mkdir -p "${currentlocale}"
				cd "${currentlocale}"
				rm -f data/patch.bif patch.key
				unpack "${a}"
				cd ..
			fi
		fi
	done )
	use hou && (
	for a in ${A}
	do
		if [ -z "${a/*$HOU_NAME}" ]
		then
			currentlocale=""
			if [ -z "${a/*German*/}" ]
			then
				currentlocale=de
			elif [ -z "${a/*English*/}" ]
			then
				currentlocale=en
			elif [ -z "${a/*Spanish*/}" ]
			then
				currentlocale=es
			elif [ -z "${a/*Italian*/}" ]
			then
				currentlocale=it
			elif [ -z "${a/*French*/}" ]
			then
				currentlocale=fr
			fi
			if [ -n "$currentlocale" ]
			then
				mkdir -p "${currentlocale}"
				cd "${currentlocale}"
				rm -f data/patch.bif patch.key data/xp1patch.bif xp1patch.key override/*
				unpack "${a}"
				cd ..
			fi
		fi
	done )
}

src_install() {
	dodir "${dir}"
	exeinto "${dir}"
	doexe "${FILESDIR}"/fixinstall
	sed -i \
		-e "s:GENTOO_USER:${GAMES_USER}:" \
		-e "s:GENTOO_GROUP:${GAMES_GROUP}:" \
		-e "s:GENTOO_DIR:${GAMES_PREFIX_OPT}:" \
		-e "s:override miles nwm:miles:" \
		-e "s:chitin.key dialog.tlk nwmain:chitin.key:" \
		-e "s:^chmod a-x:#chmod a-x:" \
		"${Ddir}"/fixinstall || die
	if use hou || use sou
	then
		sed -i \
			-e "s:chitin.key patch.key:chitin.key:" \
			"${Ddir}"/fixinstall || die
	fi
	fperms ug+x "${dir}"/fixinstall || die
	mv "${S}"/* "${Ddir}"
	mv "${S}"/.metadata "${Ddir}"
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
}
