# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Simple but powerful Qt-based image viewer"
HOMEPAGE="http://photoqt.org/"
SRC_URI="http://photoqt.org/oldRel/photo-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	media-gfx/exiv2:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/photo-0.7.1.1-install-desktop.patch"
)

S=${WORKDIR}/photo-${PV}
