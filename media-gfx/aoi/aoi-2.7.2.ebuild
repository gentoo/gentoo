# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/aoi/aoi-2.7.2.ebuild,v 1.4 2014/08/10 21:13:35 slyfox Exp $

inherit java-pkg-2 eutils versionator

MY_V=$(delete_all_version_separators)
MY_P="aoi${MY_V}"
MY_MANUAL_V="2.6"
S="${WORKDIR}/ArtOfIllusion${MY_V}"
DESCRIPTION="A free, open-source 3D modelling and rendering studio"
SRC_URI="mirror://sourceforge/aoi/${MY_P}.zip
	doc? ( mirror://sourceforge/aoi/manual${MY_MANUAL_V}.zip )"
HOMEPAGE="http://aoi.sourceforge.net/index"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"
DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"
IUSE="doc"

src_install() {
	# documentation
	dodoc HISTORY README
	if use doc ; then
		mv "${WORKDIR}"/AoI\ Manual/ "${WORKDIR}"/aoi_manual
		dohtml -r "${WORKDIR}"/aoi_manual/
	fi

	# main app
	java-pkg_dojar ArtOfIllusion.jar

	# run script
	java-pkg_dolauncher aoi \
		--jar ArtOfIllusion.jar \
		--java_args -Xmx128M

	# plugins
	mv Plugins "${D}"/usr/share/${PN}/lib

	# scripts
	mv Scripts "${D}"/usr/share/${PN}/lib

	# icon
	mv Icons/64x64.png Icons/aoi.png
	doicon Icons/aoi.png

	# desktop entry
	make_desktop_entry aoi "Art of Illusion" aoi "Graphics"
}
