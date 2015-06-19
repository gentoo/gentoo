# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/hdup/hdup-2.0.14.ebuild,v 1.9 2014/08/10 01:54:00 patrick Exp $

KEYWORDS="~amd64 ~ppc ~x86"
DESCRIPTION="Hdup is backup program using tar, find, gzip/bzip2, mcrypt and ssh"
HOMEPAGE="http://www.miek.nl/projects/hdup2/index.html"
SRC_URI="http://www.miek.nl/projects/${PN}2/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="crypt"

CDEPEND="app-arch/bzip2
		app-arch/gzip
		app-arch/tar
		>=dev-libs/glib-2.0"

RDEPEND="${CDEPEND}
		net-misc/openssh
		sys-apps/coreutils
		sys-apps/findutils
		crypt? ( app-crypt/mcrypt )"

DEPEND="${CDEPEND}
		virtual/pkgconfig"

src_unpack() {
	unpack ${A}

	sed -i \
		-e '/hdup:/s|${HDR}.*||' \
		-e 's:GLIB_LIBS *=:LDLIBS =:' \
		-e '/-o hdup/,+1d' \
		"${S}"/src/Makefile.in || die "Makefile fix failed"
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /usr/sbin
	make DESTDIR="${D}" install || die "make install failed"

	dohtml doc/FAQ.html
	dodoc ChangeLog Credits README

	insinto /usr/share/${PN}/contrib/
	doins contrib/*

	insinto /usr/share/${PN}/examples/
	doins examples/*
}

pkg_postinst() {
	elog "Now edit your /etc/hdup/${PN}.conf to configure your backups."
	elog "You can also check included examples and contrib, see /usr/share/${PN}/."
}
