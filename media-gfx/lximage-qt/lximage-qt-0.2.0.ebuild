# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/lximage-qt/lximage-qt-0.2.0.ebuild,v 1.4 2014/11/16 12:43:17 jauhien Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXImage Image Viewer - GPicView replacement"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-libs/glib:2
	media-libs/libexif
	>=x11-libs/libfm-1.2
	x11-libs/libX11
	x11-libs/libXfixes
	x11-misc/pcmanfm-qt"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
