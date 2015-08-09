# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
OPENGL_REQUIRED="always"
inherit kde4-base

DESCRIPTION="KDE image viewer"
HOMEPAGE="
	http://www.kde.org/applications/graphics/gwenview/
	http://gwenview.sourceforge.net/
"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug kipi semantic-desktop"

# tests fail, last checked 4.11.0
RESTRICT="test"

DEPEND="
	$(add_kdeapps_dep libkdcraw)
	$(add_kdeapps_dep libkonq)
	$(add_kdebase_dep kactivities '' 4.13)
	media-gfx/exiv2:=
	media-libs/lcms:2
	media-libs/libpng:0=
	virtual/jpeg:0
	x11-libs/libX11
	kipi? ( $(add_kdeapps_dep libkipi) )
	semantic-desktop? ( $(add_kdebase_dep baloo) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with kipi)
	)
	# Workaround for bug #479510
	if [[ -e ${EPREFIX}/usr/include/${CHOST}/jconfig.h ]]; then
		mycmakeargs+=( -DJCONFIG_H="${EPREFIX}/usr/include/${CHOST}/jconfig.h" )
	fi

	if use semantic-desktop; then
		mycmakeargs+=(-DGWENVIEW_SEMANTICINFO_BACKEND=Baloo)
	else
		mycmakeargs+=(-DGWENVIEW_SEMANTICINFO_BACKEND=None)
	fi

	kde4-base_src_configure
}

pkg_postinst() {
	kde4-base_pkg_postinst

	if ! has_version kde-apps/svgpart:${SLOT} ; then
		elog "For SVG support, install kde-apps/svgpart:${SLOT}"
	fi

	if use kipi && ! has_version media-plugins/kipi-plugins ; then
		elog "The plugins for the KIPI inteface can be found in media-plugins/kipi-plugins"
	fi
}
