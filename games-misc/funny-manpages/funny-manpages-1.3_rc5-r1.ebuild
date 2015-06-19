# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/funny-manpages/funny-manpages-1.3_rc5-r1.ebuild,v 1.6 2015/02/05 17:53:36 tupone Exp $
EAPI=5
inherit eutils

MY_R=${PV:0-1}
MY_P=${PN}_${PV/_rc?/}
DESCRIPTION="funny manpages collected from various sources"
HOMEPAGE="http://debian.org/"
SRC_URI="mirror://debian/pool/main/f/funny-manpages/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/f/funny-manpages/${MY_P}-${MY_R}.diff.gz"

LICENSE="freedist" #465704
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"

S=${WORKDIR}/${MY_P/_/-}.orig

src_prepare() {
	epatch ../${MY_P}-${MY_R}.diff

	for f in *.[0-57-9]fun ; do
		mv ${f} ${f/.?fun/.6fun} || die "renaming ${f} failed"
	done
}

src_install() {
	doman *.6fun
}
