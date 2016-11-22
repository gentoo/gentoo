# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="a little bus scanning, testing, and topology visualizing tool for the Linux IEEE1394 subsystem"
HOMEPAGE="https://sourceforge.net/projects/gscanbus.berlios/"
SRC_URI="mirror://sourceforge/${PN}.berlios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="sys-libs/libraw1394
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README TODO )
