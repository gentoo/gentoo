# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Common set of scripts for various PPP implementations"
HOMEPAGE="http://gentoo.org/"
SRC_URI="http://dev.gentoo.org/~pinkbyte/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"

DEPEND="!<net-dialup/ppp-2.4.7-r1"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	exeinto /etc/ppp
	for i in ip-up ip-down ; do
		doexe "scripts/${i}"
		insinto /etc/ppp/${i}.d
		dosym ${i} /etc/ppp/${i/ip/ipv6}
		doins "scripts/${i}.d"/*
	done
}
