# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin

DESCRIPTION="A GKrellM plugin that shows sunrise and sunset times"
HOMEPAGE="http://gkrellsun.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellsun/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE="nls"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-reenable.patch
	"${FILESDIR}"/${P}-Respect-LDFLAGS.patch
)

PLUGIN_SO=( src20/gkrellsun$(get_modname) )

src_compile() {
	use nls && local myconf="enable_nls=1"
	emake ${myconf}
}
