# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/nfoview/nfoview-1.9.1.ebuild,v 1.3 2010/08/09 11:13:31 hwoarang Exp $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils fdo-mime gnome2-utils
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://gitorious.org/nfoview/mainline.git"
	inherit git
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="http://download.gna.org/nfoview/1.9/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="simple viewer for NFO files, which are ASCII art in the CP437 codepage"
HOMEPAGE="http://home.gna.org/nfoview/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="dev-python/pygtk"
RDEPEND="${DEPEND}
	media-fonts/terminus-font"

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	distutils_pkg_postinst
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	distutils_pkg_postrm
}
