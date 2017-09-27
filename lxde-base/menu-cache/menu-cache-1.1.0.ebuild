# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library to create and utilize caches to speed up freedesktop application menus"
HOMEPAGE="http://lxde.sourceforge.net/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1+"
# ABI is v2. See Makefile.am
SLOT="0/2"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/libfm-extra"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_install() {
	default
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete
}
