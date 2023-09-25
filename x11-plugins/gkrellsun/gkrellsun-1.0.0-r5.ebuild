# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

DESCRIPTION="A GKrellM plugin that shows sunrise and sunset times"
HOMEPAGE="http://gkrellsun.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellsun/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc sparc x86"
IUSE="nls"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-reenable.patch
	"${FILESDIR}"/${P}-Respect-LDFLAGS.patch
	"${FILESDIR}"/${P}-r5-makefile-fixes.patch
)

src_configure() {
	PLUGIN_SO=( src20/gkrellsun$(get_modname) )
	default
}

src_compile() {
	tc-export PKG_CONFIG
	use nls && local myconf="enable_nls=1"
	emake CC="$(tc-getCC)" ${myconf}
}
