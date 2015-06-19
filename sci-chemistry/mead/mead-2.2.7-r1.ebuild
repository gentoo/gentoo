# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/mead/mead-2.2.7-r1.ebuild,v 1.1 2010/04/19 17:49:23 jlec Exp $

inherit eutils

DESCRIPTION="Macroscopic Electrostatics with Atomic Detail"
HOMEPAGE="http://www.teokem.lu.se/~ulf/Methods/mead.html"
SRC_URI="ftp://ftp.scripps.edu/pub/bashford/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE="python"

RESTRICT="fetch"

pkg_nofetch() {
	elog "Download ${SRC_URI}"
	elog "and place it in ${DISTDIR}."
	elog
	elog "Use \"anonymous\" as a login, and an email address as a password."
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-respect-flags.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	econf \
		${conf_opts} \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	# package hates emake DESTDIR="${D}" install
	einstall || die "install failed"
}
