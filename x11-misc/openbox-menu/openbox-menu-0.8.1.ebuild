# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Another dynamic menu generator for Openbox"
HOMEPAGE="http://fabrice.thiroux.free.fr/openbox-menu_en.html"
SRC_URI="https://github.com/fabriceT/openbox-menu/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+icons svg"
REQUIRED_USE="svg? ( icons )"

DEPEND="
	dev-libs/glib:2
	lxde-base/menu-cache
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}
	icons? ( x11-wm/openbox[imlib,svg?] )
	!icons? ( x11-wm/openbox )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# git master
	"${FILESDIR}/${P}-gtk3.patch"
	# downstream patches
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-makefile.patch"
)

src_compile() {
	emake CC=$(tc-getCC) PKG_CONFIG=$(tc-getPKG_CONFIG) \
		WITH_ICONS=$(usex icons '1' '0') \
		WITH_SVG=$(usex svg '1' '0')
}
