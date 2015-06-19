# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-pinentry/eselect-pinentry-0.3.ebuild,v 1.1 2015/03/31 16:54:08 ulm Exp $

DESCRIPTION="Manage /usr/bin/pinentry symlink"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="app-admin/eselect
	!<app-crypt/pinentry-0.8.0-r1"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/${P} pinentry.eselect || die
}
