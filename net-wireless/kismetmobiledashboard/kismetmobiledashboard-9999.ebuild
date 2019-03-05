# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit git-r3

DESCRIPTION="Mobile UI for kismet"
HOMEPAGE="https://github.com/elkentaro/KismetMobileDashboard"
SRC_URI=""
EGIT_REPO_URI="https://github.com/elkentaro/KismetMobileDashboard.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	KIS_SRC_DIR="/usr/share/kismet" emake
}

src_install() {
	DESTDIR="${ED}" KIS_SRC_DIR="/usr/share/kismet" emake install
}
