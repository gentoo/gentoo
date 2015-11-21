# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-baseapps"
inherit kde4-meta

DESCRIPTION="Various plugins for konqueror"
KEYWORDS=" ~amd64 ~x86"
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
		$(cmake-utils_use_with tidy LibTidy)
	)

	kde4-meta_src_configure
}
