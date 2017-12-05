# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CDROM_OPTIONAL="yes"
inherit cdrom eutils

# Not possible to apply official 1.2 patch under Linux. A Gentoo user
# created Xdelta patches and the DXX-Rebirth project kindly hosted them.
MY_PATCH="http://www.dxx-rebirth.com/download/dxx/misc/d2xptch12.tgz"

# For GOG install
MY_EXE="setup_descent2_2.1.0.10.exe"

DESCRIPTION="Data files for Descent 2"
HOMEPAGE="http://www.interplay.com/games/descent.php"
SRC_URI="cdinstall? ( ${MY_PATCH} )
	!cdinstall? ( ${MY_EXE} )"
LICENSE="descent-data"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc videos"
RESTRICT="bindist !cdinstall? ( fetch )"

# <d2x-0.2.5-r3 may include the data.
RDEPEND="!<games-action/d2x-0.2.5-r3
	!games-action/descent2-demodata"

DEPEND="cdinstall? (
		app-arch/unarj
		dev-util/xdelta:3
	)
	!cdinstall? (
		app-arch/innoextract
	)"

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
		cdrom_get_cds d2data/descent2.sow:descent2.hog

		case ${CDROM_SET} in
			0)
				einfo "Found Descent 2 CD"
				unarj e "${CDROM_ABSMATCH}" || die ;;
			1)
				einfo "Found Descent 2 installation"
				cd "${CDROM_ABSMATCH%/*}" || die ;;
		esac
	else
		einfo "Unpacking ${MY_EXE}. This will take a while..."
		innoextract -e -s -p1 -L -I app -d gog "${DISTDIR}/${MY_EXE}" || die
		cd "${WORKDIR}/gog/app" || die
	fi

	eshopts_push -s globstar nocaseglob nullglob

	# Strip directories
	# Lowercase
	# d2{-2plyr,chaos}.* into data/missions
	# *.dem into data/demos
	# Documentation into doc
	# Remainder into data
	# Exclude Vertigo files

	tar c \
		--mode=u+w \
		--ignore-case \
		--xform='s:.*/::xg' \
		--xform='s:.*:\L\0:x' \
		--xform='s:^d2(-2plyr|chaos)\.:data/missions/\0:x' \
		--xform='s:.*\.dem$:data/demos/\0:x' \
		--xform='s:.*\.(pdf|txt)$:doc/\0:x' \
		--xform='s:^[^/]+$:data/\0:x' \
		--exclude='d2x*' \
		--exclude='hoard.ham' \
		--exclude='panic.*' \
		--exclude="$(use doc || echo '*.pdf')" \
		--exclude="$(use videos || echo '*.mvl')" \
		*.{txt,pdf} *-h.mvl **/*.{ham,hog,mn2,pig,s11,s22} \
		| tar x -C "${WORKDIR}"

	assert "tar failed"
	eshopts_pop
}

src_prepare() {
	# Patch to 1.2 if necessary
	if use cdinstall; then
		if [[ $(md5sum data/descent2.ham) != 7f30c3d7d4087b8584b49012a53ce022* ]]; then
			local i
			for i in *.xdelta; do
				xdelta3 -d -s data/"${i%.*}" "${i}" data/"${i%.*}".new || die
				mv data/"${i%.*}"{.new,} || die
			done
		fi
	fi

	default
}

src_install() {
	insinto /usr/share/games/d2x
	doins -r data/*
	[[ -d doc ]] && dodoc doc/*
}

pkg_postinst() {
	elog "A client is needed to run the game, e.g. games-action/dxx-rebirth."
	echo
}
