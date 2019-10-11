# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Emulates the detach feature of screen"
HOMEPAGE="http://dtach.sourceforge.net/ https://github.com/crigler/dtach"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ~ppc64 s390 sparc x86"
IUSE=""

src_install() {
	dobin dtach
	doman dtach.1
	dodoc README
}
