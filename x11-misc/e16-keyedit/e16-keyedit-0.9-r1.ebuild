# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Key binding editor for Enlightenment DR16"
HOMEPAGE="https://www.enlightenment.org https://sourceforge.net/projects/enlightenment/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT-with-advertising"
SLOT="0"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}
	!x11-misc/e16keyedit
"

src_configure() {
	econf --with-gtk=gtk3
}
