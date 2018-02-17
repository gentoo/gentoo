# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="mkDoxy generates Doxygen-compatible HTML documentation for makefiles"
HOMEPAGE="https://sourceforge.net/projects/mkdoxy/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ia64 ~ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-doc/doxygen
	>=dev-lang/perl-5"

src_install() {
	dobin mkdoxy
	dodoc AUTHORS ChangeLog INSTALL INSTALL.gentoo README TODO VERSION
}
