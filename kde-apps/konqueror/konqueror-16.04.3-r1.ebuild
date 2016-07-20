# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
inherit flag-o-matic kde4-meta

DESCRIPTION="Web browser and file manager"
HOMEPAGE="
	https://www.kde.org/applications/internet/konqueror/
	https://konqueror.org/
"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+bookmarks debug +filemanager svg"
# 4 of 4 tests fail. Last checked for 4.0.3
RESTRICT="test"

DEPEND="
	$(add_kdeapps_dep libkonq)
	filemanager? (
		$(add_kdebase_dep kactivities '' 4.13)
		media-libs/phonon[qt4]
		x11-libs/libXrender
	)
"

# bug #544630: evince[nsplugin] crashes konqueror
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kfind)
	$(add_kdeapps_dep kfmclient)
	$(add_kdeapps_dep kurifilter-plugins)
	bookmarks? ( $(add_kdeapps_dep keditbookmarks) )
	filemanager? (
		$(add_kdeapps_dep kdebase-kioslaves)
		$(add_kdeapps_dep kfind)
		$(add_kdeapps_dep konsolepart)
		!kde-apps/dolphin:4
	)
	svg? ( $(add_kdeapps_dep svgpart) )
	!app-text/evince[nsplugin]
"

KMEXTRA="
	dolphin/
"

KMEXTRACTONLY="
	konqueror/client/
	lib/konq/
"

src_prepare() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lmalloc

	# required for dolphin
	sed -e "/konq_copytomenu.h/ s/# //" \
		-e "/konq_copytomenu.h/ s/ - anyone needs it?//" \
		-i lib/konq/CMakeLists.txt \
		|| die "Failed to fix libkonq CMakeLists.txt"

	kde4-meta_src_prepare

	use filemanager || cmake_comment_add_subdirectory dolphin

	# Do not install *.desktop files for kfmclient
	sed -e "/kfmclient\.desktop/d" -i konqueror/CMakeLists.txt \
		|| die "Failed to omit .desktop files"
}

src_configure() {
	local mycmakeargs

	if use filemanager ; then
		mycmakeargs=(
			-DWITH_Baloo=OFF
			-DWITH_BalooWidgets=OFF
			-DWITH_KFileMetaData=OFF
		)
	fi

	kde4-meta_src_configure
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if use filemanager && ! has_version media-gfx/icoutils ; then
		elog "For .exe file preview support, install media-gfx/icoutils."
	fi

	if ! has_version virtual/jre ; then
		elog "To use Java on webpages install virtual/jre."
	fi
}
