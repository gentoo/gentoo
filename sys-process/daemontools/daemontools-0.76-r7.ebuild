# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic qmail

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://cr.yp.to/daemontools.html"
SRC_URI="http://cr.yp.to/daemontools/${P}.tar.gz
	http://smarden.org/pape/djb/manpages/${P}-man-20020131.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="selinux static"

DEPEND=""
RDEPEND="selinux? ( sec-policy/selinux-daemontools )
	!app-doc/daemontools-man"

S="${WORKDIR}"/admin/${P}/src

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-errno.patch
	epatch "${FILESDIR}"/${PV}-warnings.patch
	ht_fix_file Makefile print-{cc,ld}.sh

	use static && append-ldflags -static
	qmail_set_cc
}

src_compile() {
	touch home
	emake || die
}

src_install() {
	keepdir /service

	dobin $(<../package/commands) || die
	dodoc CHANGES ../package/README TODO
	doman "${WORKDIR}"/${PN}-man/*.8

	newinitd "${FILESDIR}"/svscan.init-0.76-r7 svscan
}

pkg_postinst() {
	einfo
	einfo "You can run daemontools using the svscan init.d script,"
	einfo "or you could run it through inittab."
	einfo "To use inittab, emerge supervise-scripts and run:"
	einfo "svscan-add-to-inittab"
	einfo "Then you can hup init with the command telinit q"
	einfo
}
