# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit base linux-mod

#if LIVE
ESVN_REPO_URI="https://syntekdriver.svn.sourceforge.net/svnroot/syntekdriver/trunk/driver"
inherit subversion
#endif

DESCRIPTION="A driver for Syntek webcams often found in Asus notebooks"
HOMEPAGE="http://syntekdriver.sourceforge.net/"
SRC_URI="mirror://sourceforge/syntekdriver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

MODULE_NAMES="${PN}(media/video:)"
CONFIG_CHECK="VIDEO_V4L2"

#if LIVE
KEYWORDS=
SRC_URI=
#endif

pkg_setup() {
	linux-mod_pkg_setup

	BUILD_TARGETS="${PN}.ko"
	BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S}"

	MODULESD_STK11XX_DOCS=( README )
}
#if LIVE

src_prepare() {
	base_src_prepare
}
#endif
