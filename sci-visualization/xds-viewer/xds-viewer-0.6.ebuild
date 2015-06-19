# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/xds-viewer/xds-viewer-0.6.ebuild,v 1.5 2013/03/02 23:29:00 hwoarang Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="Viewing X-ray diffraction and control images in the context of data processing by the XDS"
HOMEPAGE="http://xds-viewer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	media-libs/libpng
	dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

DOCS="README"
HTML_DOCS="src/doc/*"
