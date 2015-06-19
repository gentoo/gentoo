# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/nfoview/nfoview-1.12.1.ebuild,v 1.1 2013/04/21 03:22:48 vapier Exp $

EAPI=3

PYTHON_DEPEND="3:3.2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.*"

inherit distutils fdo-mime gnome2-utils
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/otsaloma/nfoview.git
		http://github.com/otsaloma/nfoview.git"
	inherit git-2
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="http://download.gna.org/nfoview/${PV:0:4}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
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
	distutils_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	distutils_pkg_postrm
}
