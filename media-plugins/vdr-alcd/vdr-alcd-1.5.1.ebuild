# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-alcd/vdr-alcd-1.5.1.ebuild,v 1.3 2012/04/30 20:02:16 hd_brummy Exp $

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Control Activy 300 LCD"
HOMEPAGE="http://www.htpc-forum.de"
SRC_URI="http://www.htpc-forum.de/download/${P}.tgz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/${P}-makefile-cleanup.diff"
	"${FILESDIR}/${P}-gcc-4.4.diff")
