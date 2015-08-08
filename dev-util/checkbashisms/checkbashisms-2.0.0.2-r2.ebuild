# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Perl script to check for commonly used bash features not defined by POSIX"
# "checkbaskisms" is not a typo, it's the actual upstream SF project name.
HOMEPAGE="http://sourceforge.net/projects/checkbaskisms/"
SRC_URI="mirror://sourceforge/checkbaskisms/${PV}/${PN} -> ${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	virtual/perl-Getopt-Long
	!<dev-util/rpmdevtools-8.3-r1"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${P} ${PN}
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-export.patch #458392
	epatch "${FILESDIR}"/${P}-kill.patch #458392
	epatch "${FILESDIR}"/${P}-version.patch
}

src_install() {
	dobin ${PN}
}
