# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/linux-kernel-in-a-nutshell/linux-kernel-in-a-nutshell-1.ebuild,v 1.3 2013/02/07 21:31:30 ulm Exp $

inherit eutils

DESCRIPTION="Linux Kernel in a Nutshell: A Desktop Quick Reference"
HOMEPAGE="http://www.kroah.com/lkn/"
SRC_URI="mirror://kernel/linux/kernel/people/gregkh/lkn/lkn_pdf.tar.bz2
	mirror://kernel/linux/kernel/people/gregkh/lkn/lkn_xml.tar.bz2"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/doc/${PN}/pdf
	doins -r lkn_pdf/* || die
	insinto /usr/share/doc/${PN}/xml
	doins -r lkn_xml/* || die
}
