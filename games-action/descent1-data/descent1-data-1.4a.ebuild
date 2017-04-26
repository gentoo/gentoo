# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CDROM_OPTIONAL="yes"
inherit cdrom eutils

# For GOG install
MY_EXE="setup_descent_2.1.0.8.exe"

DESCRIPTION="Data files for Descent 1"
HOMEPAGE="http://www.interplay.com/games/descent.php"
SRC_URI="cdinstall? ( http://www.dxx-rebirth.com/download/dxx/misc/descent-game-content-10to14a-patch.zip )
	!cdinstall? ( ${MY_EXE} )"
LICENSE="descent-data"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="bindist !cdinstall? ( fetch )"

RDEPEND="!games-action/descent1-demodata"

DEPEND="cdinstall? ( app-arch/unzip )
	!cdinstall? ( app-arch/innoextract )"

S="${WORKDIR}"

pkg_nofetch() {
	elog "You must place a copy of, or symlink to, the GOG setup package here:"
	elog "${DISTDIR}/${MY_EXE}"
	echo
	elog "If you wish to install from CD-ROM instead, please enable the cdinstall flag."
}

src_unpack() {
	if use cdinstall; then
		default
		cdrom_get_cds descent/descent.hog:descent.hog

		case ${CDROM_SET} in
			0) einfo "Found Descent 1 CD" ;;
			1) einfo "Found Descent 1 installation" ;;
		esac

		cd "${CDROM_ABSMATCH%/*}" || die
	else
		innoextract -e -s -p0 -L -I app -d gog "${DISTDIR}/${MY_EXE}" || die
		cd "${WORKDIR}/gog/app" || die
	fi

	eshopts_push -s globstar nocaseglob nullglob

	# Strip directories
	# Lowercase
	# chaos.* into data/missions
	# *.dem into data/demos
	# Documentation into doc
	# Remainder into data

	tar c \
		--mode=u+w \
		--ignore-case \
		--xform='s:.*/::xg' \
		--xform='s:.*:\L\0:x' \
		--xform='s:^chaos\.:data/missions/\0:x' \
		--xform='s:.*\.dem$:data/demos/\0:x' \
		--xform='s:.*\.(faq|pdf|txt)$:doc/\0:x' \
		--xform='s:^[^/]+$:data/\0:x' \
		--exclude="$(use doc || echo '*.pdf')" \
		*.{faq,txt,pdf} **/*.{dem,hog,msn,pig} \
		| tar x -C "${WORKDIR}"

	assert "tar failed"
	eshopts_pop
}

src_prepare() {
	if use cdinstall; then
		case $(md5sum data/descent.hog || die) in
			8adfff2e5205486cd5574ac3dd0b4381*)
				patch -p0 data/descent.hog < descent.hog.diff || die ;;
			c792a21a30b869b1ec6d31ad64e9557e*)
				einfo "descent.hog already patched" ;;
			*)
				ewarn "Unknown descent.hog detected, cannot patch" ;;
		esac

		case $(md5sum data/descent.pig || die) in
			7916448ae69bcc0dd4f3b057a961285f*)
				patch -p0 data/descent.pig < descent.pig.diff || die ;;
			fa7e48b7b1495399af838e31ac13b7da*)
				einfo "descent.pig already patched" ;;
			*)
				ewarn "Unknown descent.pig detected, cannot patch" ;;
		esac
	fi

	default
}

src_install() {
	insinto /usr/share/games/d1x
	doins -r data/*
	[[ -d doc ]] && dodoc doc/*
}

pkg_postinst() {
	elog "A client is needed to run the game, e.g. games-action/dxx-rebirth."
	echo
}
