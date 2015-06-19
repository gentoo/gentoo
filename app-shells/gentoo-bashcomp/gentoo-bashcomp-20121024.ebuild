# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/gentoo-bashcomp/gentoo-bashcomp-20121024.ebuild,v 1.11 2014/01/19 10:12:40 vapier Exp $

EAPI=4
inherit eutils prefix

DESCRIPTION="Gentoo-specific bash command-line completions (emerge, ebuild, equery, repoman, layman, etc)"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris"
IUSE=""

RDEPEND="app-shells/bash-completion"

src_prepare() {
	eprefixify gentoo
}

src_compile() {	:; } # There is a useless Makefile in the distfile

src_install() {
	insinto /usr/share/bash-completion
	doins gentoo 	|| die "failed to install gentoo module"
	doins repoman 	|| die "failed to install repoman module"
	doins layman 	|| die "failed to install layman module"
	dodoc AUTHORS ChangeLog TODO
}

pkg_postinst() {
	# can't use bash-completion.eclass.
	elog "To enable command-line completion for ${PN}, run:"
	elog
	elog "  eselect bashcomp enable gentoo"
	elog
	elog "to install locally, or"
	elog
	elog "  eselect bashcomp enable --global gentoo"
	elog
	elog "to install system-wide. (and/or repoman instead of gentoo if you use"
	elog "repoman frequently)"
}
