# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KMNAME="kde-baseapps"
inherit flag-o-matic kde4-meta

DESCRIPTION="KDE: Web browser and file manager"
HOMEPAGE="
	https://www.kde.org/applications/internet/konqueror/
	http://konqueror.org/
"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+bookmarks debug svg"
# 4 of 4 tests fail. Last checked for 4.0.3
RESTRICT="test"

DEPEND="
	$(add_kdeapps_dep libkonq)
"

# bug #544630: evince[nsplugin] crashes konqueror
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kfind)
	$(add_kdeapps_dep kfmclient)
	$(add_kdeapps_dep kurifilter-plugins)
	bookmarks? ( $(add_kdeapps_dep keditbookmarks) )
	svg? ( $(add_kdeapps_dep svgpart) )
	!app-text/evince[nsplugin]
"

KMEXTRACTONLY="
	konqueror/client/
	lib/konq/
"

src_prepare() {
	[[ ${CHOST} == *-solaris* ]] && append-ldflags -lmalloc

	kde4-meta_src_prepare

	# Do not install *.desktop files for kfmclient
	sed -e "/kfmclient\.desktop/d" -i konqueror/CMakeLists.txt \
		|| die "Failed to omit .desktop files"
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-apps/dolphin:${SLOT} ; then
		elog "If you want to use konqueror as a filemanager, install the dolphin kpart:"
		elog "kde-apps/dolphin:${SLOT}"
	fi

	if ! has_version virtual/jre ; then
		elog "To use Java on webpages install virtual/jre."
	fi
}
