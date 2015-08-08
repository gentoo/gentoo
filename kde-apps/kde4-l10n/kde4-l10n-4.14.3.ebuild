# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE internationalization package"
HOMEPAGE="http://l10n.kde.org"

DEPEND="
	sys-devel/gettext
"
RDEPEND="!<kde-base/konq-plugins-4.6"

KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="minimal"

# /usr/portage/distfiles $ ls -1 kde-l10n-*-${PV}.* |sed -e 's:-${PV}.tar.xz::' -e 's:kde-l10n-::' |tr '\n' ' '
MY_LANGS="ar bg bs ca ca@valencia cs da de el en_GB es et eu fa fi fr ga gl he
hi hr hu ia id is it ja kk km ko lt lv mr nb nds nl nn pa pl pt pt_BR ro ru sk
sl sr sv tr ug uk wa zh_CN zh_TW"

URI_BASE="${SRC_URI/-${PV}.tar.xz/}"
SRC_URI=""

for MY_LANG in ${MY_LANGS} ; do
	IUSE="${IUSE} linguas_${MY_LANG}"
	SRC_URI="${SRC_URI} linguas_${MY_LANG}? ( ${URI_BASE}/kde-l10n-${MY_LANG}-${PV}.tar.xz )"
done

S="${WORKDIR}"

src_unpack() {
	local LNG DIR
	if [[ -z ${A} ]]; then
		elog
		elog "You either have the LINGUAS variable unset, or it only"
		elog "contains languages not supported by ${P}."
		elog "You won't have any additional language support."
		elog
		elog "${P} supports these language codes:"
		elog "${MY_LANGS}"
		elog
	fi

	[[ -n ${A} ]] && unpack ${A}
	cd "${S}"

	# add all linguas to cmake
	if [[ -n ${A} ]]; then
		for LNG in ${LINGUAS}; do
			DIR="kde-l10n-${LNG}-${PV}"
			if [[ -d "${DIR}" ]] ; then
				echo "add_subdirectory( ${DIR} )" >> "${S}"/CMakeLists.txt
			fi
		done
	fi
}

src_prepare() {
	find "${S}" -name CMakeLists.txt -type f \
		-exec sed -i -e 's:^ *add_subdirectory( *kdepim-runtime *):# no kdepim-runtime:g' {} +
	find "${S}" -name CMakeLists.txt -type f \
		-exec sed -i -e 's:^ *add_subdirectory( *kdepim *):# no kdepim:g' {} +

	# quick workaround for bug 493278
	find "${S}" -name "akonadi_knut_resource*" -delete

				# Drop translations that get installed with plasma 5 and kde apps 5 packages
				if use minimal; then

					# KDE Workspace 4
					rm -f "${S}"/*/messages/kde-workspace/{freespacenotifier,\
joystick,kaccess,kcmaccess,kcm_autostart,kcmbell,kcmcolors,kcm_desktoppaths,\
kcm_desktopthemedetails,kcmdevinfo,kcmfonts,kcm_infobase,kcminfo,\
kcm_infosummary,kcminit,kcminput,kcmkclock,kcmkeyboard,kcmkeys,\
kcmkwincompositing,kcmkwindecoration,kcm_kwindesktop,kcmkwinrules,\
kcmkwinscreenedges,kcm-kwin-scripts,kcm_kwintabbox,kcmkwm,kcmlaunch,kcm_memory,\
kcmnic,kcmopengl,kcm_pci,kcmsamba,kcmsmserver,kcm_solid_actions,\
kcm_standard_actions,kcmstyle,kcmusb,kcmview1394,kcmworkspaceoptions,kfontinst,\
khotkeys,kinfocenter,klipper,kmenuedit,krdb,krunner,kscreenlocker_greet,\
kscreenlocker,ksgrd,ksmserver,ksplashthemes,ksysguardlsofwidgets,ksysguard,\
ktouchpadenabler,kwin_clients,kwin_effects,kwin,kwin_scripting,libkdecorations,\
libkworkspace,liboxygenstyleconfig,libpowerdevilcommonconfig,libtaskmanager,\
plasma_applet_quicklaunch,plasma_applet_system-monitor,\
plasma_applet_webbrowser,plasma_containmentactions_contextmenu,\
plasma_containmentactions_switchwindow,plasma_engine_keystate,\
plasma_engine_mpris2,plasma_engine_network,plasma_engine_notifications,\
plasma_engine_rss,plasma_engine_share,plasma_engine_soliddevice,\
plasma_engine_weather,plasma_runner_activities,plasma_runner_bookmarksrunner,\
plasma_runner_calculatorrunner,plasma_runner_kill,plasma_runner_locations,\
plasma_runner_placesrunner,plasma_runner_plasma-desktop,\
plasma_runner_powerdevil,plasma_runner_recentdocuments,plasma_runner_services,\
plasma_runner_sessions,plasma_runner_shell,plasma_runner_solid,\
plasma_runner_webshortcuts,plasma_runner_windowedwidgets,plasma_runner_windows,\
powerdevilactivitiesconfig,powerdevilglobalconfig,powerdevil,\
powerdevilprofilesconfig,processcore,processui,systemsettings}.po

					# KDE Runtime 4
					rm -f "${S}"/*/messages/kde-runtime/{attica_kde,drkonqi,\
filetypes,htmlsearch,kcmcomponentchooser,kcm_emoticons,kcmhtmlsearch,\
kcmicons,kcmkded,kcmnotify,kcm_phonon,kcmshell,kdesu,kglobalaccel,\
khelpcenter,kio_applications,kio_archive,kio_bookmarks,kioclient,\
kio_fish,kio_info,kio_man,kio_nfs,kio_recentdocuments,kio_remote,\
kio_sftp,kio_smb,kio_thumbnail,kmimetypefinder,knetattach,kstart,\
ktraderclient,phonon_kde,soliduiserver}.po

					# KDE Plasma Addons 4
					rm -f "${S}"/*/messages/kdeplasma-addons/{konqprofiles,\
konsoleprofiles,lancelot,liblancelot-datamodels,libplasma_groupingcontainment,\
libplasmaweather,plasma_applet_binaryclock,plasma_applet_bookmarks,\
plasma_applet_bubblemon,plasma_applet_CharSelectApplet,plasma_applet_comic,\
plasma_applet_fifteenPuzzle,plasma_applet_fileWatcher,plasma_applet_frame,\
plasma_applet_groupingpanel,plasma_applet_incomingmsg,\
plasma_applet_knowledgebase,plasma_applet_kolourpicker,plasma_applet_leavenote,\
plasma_applet_life,plasma_applet_luna,plasma_applet_magnifique,\
plasma_applet_microblog,plasma_applet_news,plasma_applet_plasmaboard,\
plasma_applet_previewer,plasma_applet_qalculate,plasma_applet_qstardict,\
plasma_applet_rssnow,plasma_applet_showdashboard,plasma_applet_showdesktop,\
plasma_applet_spellcheck,plasma_applet_unitconverter,plasma_applet_weather,\
plasma_applet_weatherstation,plasma_applet_webslice,\
plasma_packagestructure_comic,plasma_runner_audioplayercontrol,\
plasma_runner_browserhistory,plasma_runner_CharacterRunner,\
plasma_runner_contacts,plasma_runner_converterrunner,plasma_runner_datetime,\
plasma_runner_events,plasma_runner_katesessions,\
plasma_runner_konquerorsessions,plasma_runner_konsolesessions,\
plasma_runner_kopete,plasma_runner_krunner_dictionary,plasma_runner_mediawiki,\
plasma_runner_spellcheckrunner,plasma_runner_translator,plasma_runner_youtube}.po

					# KDELIBS 4
					rm -f "${S}"/*/messages/kdelibs/{akonadi_baloo_indexer,\
baloo_file,baloo_file_extractor,baloosearch,balooshow,kcm_baloofile,kfilemetadata,\
kio_baloosearch,kio_tags,kio_timeline,plasma_runner_baloosearchrunner}.po

					# KDE Applications 4
					rm -f "${S}"/*/messages/applications/useraccount.po
				fi

	kde4-base_src_prepare
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_build handbook docs)
	)
	[[ -n ${A} ]] && kde4-base_src_configure
}

src_compile() {
	[[ -n ${A} ]] && kde4-base_src_compile
}

src_test() {
	[[ -n ${A} ]] && kde4-base_src_test
}

src_install() {
	[[ -n ${A} ]] && kde4-base_src_install
}
