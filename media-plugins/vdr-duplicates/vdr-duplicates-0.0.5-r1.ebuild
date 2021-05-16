# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: show duplicated records"
HOMEPAGE="http://www.tolleri.net/vdr/"
SRC_URI="http://www.tolleri.net/vdr/plugins/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${VDRPLUGIN}-${PV}_Makefile-new.diff" )
