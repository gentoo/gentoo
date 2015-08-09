# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: (Un)Mount removable media via osd"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Mount-plugin"
SRC_URI="http://homepages.physik.uni-muenchen.de/~Felix.Rauscher/${P}.tgz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"

PATCHES=("${FILESDIR}/${P}-makefile-fix.diff")

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-2.1.2"; then
		sed -e "s#VideoDirectory#cVideoDirectory::Name\(\)#" \
			-i MediumItem.C
	fi
}
