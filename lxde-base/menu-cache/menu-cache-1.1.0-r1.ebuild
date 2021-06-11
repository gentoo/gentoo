# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library to create and utilize caches to speed up freedesktop application menus"
HOMEPAGE="https://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/2" # ABI is v2. See Makefile.am
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/libfm-extra
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.diff # upstream PR#19
	"${FILESDIR}"/${P}-memleak.patch # git master
)

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
