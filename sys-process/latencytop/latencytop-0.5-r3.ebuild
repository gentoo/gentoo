# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info toolchain-funcs

DESCRIPTION="Tool for identifying where in the system latency is happening"
HOMEPAGE="http://git.infradead.org/latencytop.git"
# Upstream is long gone, so we explicitly use our mirrors for the tarball
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="gtk"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses:=
	gtk? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# Upstream is dead, so there are no bugs to track for any
# of these patches.
PATCHES=(
	"${FILESDIR}/${P}-01-mkdir-usr-sbin-as-well.patch"
	"${FILESDIR}/${P}-03-clean-up-build-system.patch"
	"${FILESDIR}/${P}-fsync-drop.patch"
	"${FILESDIR}/${P}-Fix-Wimplicit-int.patch"
)

CONFIG_CHECK="~LATENCYTOP"

pkg_pretend() {
	linux-info_pkg_setup
}

src_prepare() {
	default

	# Without a configure script, we toggle bools manually
	# This also needs to be done after patches are applied
	# since this bool doesn't exist outside our patches
	if ! use gtk; then
		sed -i -e "/HAS_GTK_GUI = 1/d" Makefile || die
	fi
}

src_compile() {
	tc-export CC PKG_CONFIG

	emake CPPFLAGS="${CPPFLAGS}"
}
