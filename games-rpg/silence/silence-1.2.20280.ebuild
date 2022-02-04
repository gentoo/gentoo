# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

DESCRIPTION="3D point and click adventure, sequel to The Whispered World"
HOMEPAGE="https://www.daedalic.com/silence"
SRC_URI="Silence_${PV}_Linux_Full_EN_DE_IT_ES_FR_ZH_JA_PT_KO_RU_PL_EL_Daedalic_noDRM.zip"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="l10n_de +l10n_en l10n_pl l10n_zh"
REQUIRED_USE="|| ( ${IUSE//+} )"
RESTRICT="bindist fetch splitdebug strip"

BDEPEND="app-arch/unzip"

RDEPEND="
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXrandr
"

S="${WORKDIR}"
DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default

	MY_ARCH=$(usex amd64 x86_64 x86)
	OTHER_ARCH=$(usex amd64 x86 x86_64)

	# Delete files for the other architecture.
	# Delete Steam library because we're not running under Steam.
	# Delete Screen Selector library, because it requires GTK2 but is unused.
	rm -rv \
		Silence_Data/{Mono,Plugins}/${OTHER_ARCH}/ \
		Silence_Data/Plugins/${MY_ARCH}/{libDaedalic.Ecosystems.Steam.External,ScreenSelector}.so \
		|| die

	# Remove unneeded language files.
	local locale localedir
	for locale in ${IUSE//+}; do
		if [[ ${locale} = l10n_* ]] && ! use ${locale}; then
			case ${locale#l10n_} in
				de) localedir=german ;;
				en) localedir=english ;;
				pl) localedir=polish ;;
				zh) localedir=chinese ;;
				 *) die "unrecognised locale ${locale}" ;;
			esac
			rm -rv Silence_Data/GameData/Sounds/{LipSync,Voice}/${localedir}/ || die
		fi
	done
}

src_install() {
	exeinto "${DIR}"
	newexe Silence.${MY_ARCH} Silence
	make_wrapper ${PN} ./Silence "${DIR}"

	insinto "${DIR}"
	doins -r Silence_Data version.txt

	local libdir
	for libdir in Mono Plugins; do
		exeinto "${DIR}"/Silence_Data/${libdir}/${MY_ARCH}
		doexe Silence_Data/${libdir}/${MY_ARCH}/*.so
	done

	newicon -s 128 Silence_Data/Resources/UnityPlayer.png silence.png
	make_desktop_entry ${PN} Silence
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! use l10n_en; then
		ewarn "You have disabled the English voice audio and lip sync data. The game"
		ewarn "still defaults to English though, so you will need to manually change"
		ewarn "the voice language in the options menu."
	fi
}
