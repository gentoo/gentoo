# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
DESCRIPTION="Quotes from George W. Bush"
HOMEPAGE="http://dubya.seiler.us/"
SRC_URI="http://seiler.us/wiki/images/8/8c/Dubya-${PV}.tar.gz"

LICENSE="fairuse"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~m68k ~mips ~ppc64 ~s390 ~sh ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/fortune-mod-/}

src_install() {
	insinto /usr/share/fortune
	doins dubya dubya.dat
}
