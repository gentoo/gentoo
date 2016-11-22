# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="X-ray diffraction/control image viewer in the context of data processing by XDS"
HOMEPAGE="http://xds-viewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng:0=
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

HTML_DOCS=( src/doc/. )
PATCHES=( "${FILESDIR}"/${P}-fix-c++14.patch )
