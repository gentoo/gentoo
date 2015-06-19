# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-excessiveplus/quake3-excessiveplus-2.2b.ebuild,v 1.2 2014/04/18 07:08:53 ulm Exp $

EAPI=2

MOD_DESC="modification making the weapons much faster and stronger"
MOD_NAME="Excessive Plus"
MOD_DIR="excessiveplus"
MOD_ICON="excessiveplus.ico"

inherit games games-mods

HOMEPAGE="http://www.excessiveplus.net/"
SRC_URI="http://www.excessiveplus.net/files/release/xp-${PV}.zip"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dedicated opengl"

src_prepare() {
	rm -f *.bat
	rm -rf ${MOD_DIR}/tools
}
