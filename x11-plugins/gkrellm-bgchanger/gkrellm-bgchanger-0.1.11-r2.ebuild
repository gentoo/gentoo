# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gkrellm-plugin toolchain-funcs

MY_PN="gkrellmbgchg2"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Plugin for GKrellM2 to change your desktop background"
HOMEPAGE="http://www.bender-suhl.de/stefan/english/comp/gkrellmbgchg.html"
SRC_URI="http://www.bender-suhl.de/stefan/comp/sources/${MY_P}.tar.gz"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="app-admin/gkrellm[X]"
DEPEND="${RDEPEND}"

PLUGIN_SO="gkrellmbgchg.so"
PLUGIN_DOCS="bgchg_info.sh kdewallpaper.sh"

src_prepare() {
	default
	sed -i "s:local/::" Makefile || die
	tc-export CC
}
