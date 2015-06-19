# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/obconf-qt/obconf-qt-0.1.0.ebuild,v 1.3 2014/11/16 12:44:39 jauhien Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="Openbox window manager configuration tool"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

S=${WORKDIR}

RDEPEND="dev-libs/glib:2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	x11-wm/openbox:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
