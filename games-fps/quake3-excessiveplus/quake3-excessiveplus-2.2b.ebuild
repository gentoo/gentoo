# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
