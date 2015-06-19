# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-duplicates/vdr-duplicates-0.0.5-r1.ebuild,v 1.1 2015/02/06 18:59:53 hd_brummy Exp $

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
