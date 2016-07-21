# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils prefix

DESCRIPTION="translates acronyms for you"
HOMEPAGE="http://netbsd.org/"
SRC_URI="http://dev.gentooexperimental.org/~darkside/distfiles/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
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
