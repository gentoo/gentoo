# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides files needed for LXDE application menus"
HOMEPAGE="https://lxde.org/"
SRC_URI="https://downloads.sourceforge.net/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ~ppc64 ~riscv x86"
IUSE=""

BDEPEND="
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README
}
