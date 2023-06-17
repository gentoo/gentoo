# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

MY_PN="gkrellmbgchg2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Plugin for GKrellM2 to change your desktop background"
HOMEPAGE="http://www.bender-suhl.de/stefan/english/comp/gkrellmbgchg.html"
SRC_URI="http://www.bender-suhl.de/stefan/comp/sources/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.1.11-fix-build-system.patch )

PLUGIN_DOCS=( bgchg_info.sh kdewallpaper.sh )

src_configure() {
	tc-export CC PKG_CONFIG

	PLUGIN_SO=( gkrellmbgchg$(get_modname) )
}
