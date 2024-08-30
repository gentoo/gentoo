# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MY_P="LogMon-${PV}"
DESCRIPTION="Split-screen terminal/ncurses based log viewer"
HOMEPAGE="http://www.edespot.com/logmon/"
SRC_URI="http://www.edespot.com/logmon/files/${MY_P}.tar.bz2 -> ${P}.r1.tar.bz2"
S="${WORKDIR}/${PV}/${MY_P}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PATCHES=(
	# Bug 119403 - should be in upstream next release
	"${FILESDIR}"/${P}-char2int.diff

	# Bug 250602, gcc43 fix
	"${FILESDIR}"/${P}-gcc43.patch

	# Fixes maintainer-mode detected.
	"${FILESDIR}"/${P}-maintainer-mode.patch

	"${FILESDIR}"/${P}-tinfo.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# Uses removed 'register' keyword, bug #894206
	append-cxxflags -std=c++14

	econf
}

src_install() {
	dobin logmon

	dodoc AUTHORS ChangeLog README TODO
}
