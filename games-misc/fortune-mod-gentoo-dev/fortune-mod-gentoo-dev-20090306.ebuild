# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
DESCRIPTION="Fortune database of #gentoo-dev quotes"
HOMEPAGE="https://www.gentoo.org/"
MY_PN="fortune-gentoo-dev"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2
		 https://dev.gentoo.org/~robbat2/distfiles/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="offensive"

RDEPEND="games-misc/fortune-mod"
# Perl is used to build stuff only
# and strfile belongs to fortune-mod
DEPEND="dev-lang/perl
		${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	default
	use offensive || rm -f "${D}"/usr/share/fortune/off/*
}
