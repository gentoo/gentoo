# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic

DESCRIPTION="configuration tool for setting traffic bandwidth parameters"
HOMEPAGE="ftp://archive.download.redhat.com/pub/redhat/linux/9/en/os/i386/SRPMS http://sourceforge.net/projects/cbqinit"
SRC_URI="mirror://gentoo/shaper.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/shaper

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/shapercfg-2.0.36-glibc.patch
	rm -f Makefile
}

src_compile() {
	append-flags -Wall
	emake shapecfg || die
}

src_install() {
	dobin shapecfg || die
	dodoc "${FILESDIR}"/README.shaper
}
