# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=5
MY_PN=${PN/mod-/}
DESCRIPTION="set of fortunes based on the Tao-Teh-Ching"
HOMEPAGE="http://fortunes.quotationsbook.com/fortunes/collection/67/TAO"
SRC_URI="mirror://gentoo/${MY_PN}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~m68k ~mips ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${MY_PN}

src_install() {
	insinto /usr/share/fortune
	doins tao tao.dat
}
