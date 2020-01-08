# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="471cab933bf9e5a299d07e7cb1c0851e31e299f2"
KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="CD ripper and audio encoder frontend based on KDE Frameworks"
HOMEPAGE="https://kde.org/applications/multimedia/kaudiocreator/"
SRC_URI="https://github.com/KDE/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep solid)
	$(add_kdeapps_dep libkcddb)
	$(add_kdeapps_dep libkcompactdisc)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	media-libs/libdiscid
	media-libs/phonon[qt5(+)]
	>=media-libs/taglib-1.5
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep audiocd-kio)
"

DOCS=( Changelog TODO )

pkg_postinst() {
	local stcnt=0

	has_version media-libs/flac && stcnt=$((stcnt+1))
	has_version media-sound/lame && stcnt=$((stcnt+1))
	has_version media-sound/vorbis-tools && stcnt=$((stcnt+1))

	if [[ ${stcnt} -lt 1 ]] ; then
		elog "You should emerge at least one of the following packages"
		elog "for ${PN} to do anything useful."
	fi
	elog "Optional runtime dependencies:"
	elog "FLAC - media-libs/flac"
	elog "MP3  - media-sound/lame"
	elog "OGG  - media-sound/vorbis-tools"

	kde5_pkg_postinst
}

S="${WORKDIR}/${PN}-${COMMIT}"
