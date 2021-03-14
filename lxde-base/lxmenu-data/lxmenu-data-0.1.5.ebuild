# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides files needed for LXDE application menus"
HOMEPAGE="https://lxde.org/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
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
