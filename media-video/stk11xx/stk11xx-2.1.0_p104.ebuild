# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit base linux-mod

DESCRIPTION="A driver for Syntek webcams often found in Asus notebooks"
HOMEPAGE="http://syntekdriver.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"

MODULE_NAMES="${PN}(media/video:)"
CONFIG_CHECK="VIDEO_V4L2"

pkg_setup() {
	linux-mod_pkg_setup

	BUILD_TARGETS="${PN}.ko"
	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S}"

	MODULESD_STK11XX_DOCS=( README )
}
