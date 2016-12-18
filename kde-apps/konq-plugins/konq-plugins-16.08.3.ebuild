# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kde-baseapps"
inherit kde4-meta

DESCRIPTION="Various plugins for konqueror"
KEYWORDS="amd64 ~arm x86"
IUSE="debug tidy"

DEPEND="
	$(add_kdeapps_dep libkonq)
	tidy? ( app-text/htmltidy )
"
RDEPEND="${DEPEND}
	!kde-misc/konq-plugins
	$(add_kdeapps_dep kcmshell)
	$(add_kdeapps_dep konqueror)
"

src_configure() {
	local mycmakeargs=(
		-DKdeWebKit=OFF
		-DWebKitPart=OFF
		-DWITH_LibTidy=$(usex tidy)
	)

	kde4-meta_src_configure
}
