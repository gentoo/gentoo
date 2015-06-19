# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mimd/mimd-0.30.1.ebuild,v 1.6 2014/08/10 21:07:58 slyfox Exp $

EAPI=2
inherit eutils

DESCRIPTION="Multicast streaming server for MPEG1/2 and MP3 files"
HOMEPAGE="http://darkwing.uoregon.edu/~tkay/mim.html"
SRC_URI="http://darkwing.uoregon.edu/~tkay/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

RDEPEND=">=media-plugins/live-2006.12.08
	dev-libs/xerces-c"
DEPEND="${RDEPEND}
	dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}"/${P}+live-2006.12.08.patch \
		"${FILESDIR}"/${P}-fortify_sources.patch
	cp -f Makefile.in Makefile
}

src_configure() { :; }

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin mimd || die "dobin failed"
	dodoc doc/mimd.pod

	if [ -x /usr/bin/pod2html ]; then
		pod2html < doc/mimd.pod > doc/mimd.html
		dohtml doc/mimd.html
	fi

	if [ -x /usr/bin/pod2man ]; then
		pod2man < doc/mimd.pod > doc/mimd.1
		doman doc/mimd.1
	fi

	insinto /usr/share/mimd
	doins etc/mimd.dtd etc/sample.xml
}

pkg_postinst() {
	elog "Please read the documentation (mimd.html or man mimd) for "
	elog "instructions on configuring mimd. The DTD for the configuration "
	elog "files is in /usr/share/mimd/mimd.dtd, along with a sample "
	elog "configuration file (/usr/share/mimd/sample.xml)."
	ewarn "NOTE: You must have ip multicasting enabled in the kernel for this"
	ewarn "daemon to work properly."
}
