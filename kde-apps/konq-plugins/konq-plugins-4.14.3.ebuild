# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/konq-plugins/konq-plugins-4.14.3.ebuild,v 1.1 2015/06/04 18:44:41 kensington Exp $

EAPI=5

KMNAME="kde-baseapps"
inherit kde4-meta

DESCRIPTION="Various plugins for konqueror"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
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
