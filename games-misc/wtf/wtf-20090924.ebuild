# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils prefix

DESCRIPTION="translates acronyms for you"
HOMEPAGE="http://netbsd.org/"
SRC_URI="http://dev.gentooexperimental.org/~darkside/distfiles/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~s390 ~sh ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="!games-misc/bsd-games"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-prefix.patch
	eprefixify wtf
}

src_compile() {
	:
}

src_install() {
	dobin wtf
	doman wtf.6
	insinto /usr/share/misc
	doins acronyms*
	dodoc README
}
