# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/phototonic/phototonic-1.5.54.ebuild,v 1.1 2015/03/15 09:42:43 yngwin Exp $

EAPI=5
inherit qmake-utils

DESCRIPTION="Image viewer and organizer"
HOMEPAGE="http://oferkv.github.io/phototonic/"
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/oferkv/phototonic.git"
	KEYWORDS=""
else
	SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="svg tiff"

RDEPEND="dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	media-gfx/exiv2:=
	svg? ( dev-qt/qtsvg:5 )
	tiff? ( dev-qt/qtimageformats:5 )"
DEPEND="${RDEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
