# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Qt application for getting screenshots"
HOMEPAGE="http://screengrab.doomer.org"
# Mirror the tarball because upstream failed to provide a proper way to get it
SRC_URI="http://screengrab.doomer.org/download/screengrab-1_0_/  -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-libs/libX11
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-detect-lib64.patch )

src_prepare() {
	# Install docs into the right dir, but skip the license.
	sed -i -e "/SG_DOCDIR/s:screengrab:${PF}:" \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}
