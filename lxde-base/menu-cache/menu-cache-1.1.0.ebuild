# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library to create and utilize caches to speed up freedesktop application menus"
HOMEPAGE="https://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="LGPL-2.1+"
# ABI is v2. See Makefile.am
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/libfm-extra"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

# Fix for gcc 10 / -fno-common
# https://github.com/lxde/menu-cache/pull/19
PATCHES="${FILESDIR}/${P}-fno-common.diff"

src_configure() {
	econf "--disable-static"
}
