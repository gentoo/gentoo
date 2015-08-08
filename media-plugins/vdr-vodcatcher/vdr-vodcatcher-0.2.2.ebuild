# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Downloads rss-feeds and passes video enclosures to the mplayer plugin"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-vodcatcher"
SRC_URI="mirror://vdr-developerorg/154/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/curl
		>=dev-libs/tinyxml-2.6.1[stl]
		media-video/vdr"
RDEPEND="${DEPEND}
		|| ( media-plugins/vdr-mplayer media-plugins/vdr-xineliboutput )"

PATCHES=( "${FILESDIR}/${P}_unbundle-tinyxml2.diff"
		 "${FILESDIR}/${P}_gcc-4.7.patch" )

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -e "s:ConfigDirectory():ConfigDirectory( \"vodcatcher\" ):" -i src/VodcatcherPlugin.cc
}

src_install() {
	vdr-plugin-2_src_install

	insinto /etc/vdr/plugins/vodcatcher/
	doins   examples/vodcatchersources.conf
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	echo
	elog "! IMPORTEND"
	elog "In order to allow the MPlayer plug-in to play back the streams passed in by the"
	elog "Vodcatcher, you must add the following entry to the mplayersources.conf file:"
	echo
	elog "/tmp;Vodcatcher;0"
	echo
}
