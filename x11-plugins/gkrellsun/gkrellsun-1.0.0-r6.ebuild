# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin multilib toolchain-funcs

DESCRIPTION="A GKrellM plugin that shows sunrise and sunset times"
HOMEPAGE="https://gkrellsun.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/gkrellsun/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc sparc x86"
IUSE="nls"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-reenable.patch
	"${FILESDIR}"/${P}-Respect-LDFLAGS.patch
	"${FILESDIR}"/${P}-r6-makefile-fixes.patch
	"${FILESDIR}"/${P}-r6-include.patch
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
