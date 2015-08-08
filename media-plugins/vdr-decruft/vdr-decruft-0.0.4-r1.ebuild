# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: Clean unwanted entries from channels.conf"
HOMEPAGE="http://www.rst38.org.uk/vdr/decruft/"
SRC_URI="http://www.rst38.org.uk/vdr/decruft/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.3.21-r2"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/${P}-avoid-vdr-patch.diff"
		"${FILESDIR}/${P}_compile.patch")

src_install() {
	vdr-plugin-2_src_install
	insinto /etc/vdr/plugins
	doins examples/decruft.conf
}
