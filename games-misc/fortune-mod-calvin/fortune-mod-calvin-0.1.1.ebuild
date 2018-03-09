# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Quotes from Calvin and Hobbes Comic Books"
HOMEPAGE="http://www.netmeister.org/misc.html"
SRC_URI="http://www.netmeister.org/apps/${P}.tar.gz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

src_install() {
	insinto /usr/share/fortune
	doins calvin calvin.dat
}
