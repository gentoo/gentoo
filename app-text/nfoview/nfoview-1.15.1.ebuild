# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1 fdo-mime gnome2-utils
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/otsaloma/nfoview.git
		https://github.com/otsaloma/nfoview.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="http://download.gna.org/nfoview/${PV:0:4}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="simple viewer for NFO files, which are ASCII art in the CP437 codepage"
HOMEPAGE="http://home.gna.org/nfoview/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/pygobject:3"
RDEPEND="${DEPEND}
	media-fonts/terminus-font"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
