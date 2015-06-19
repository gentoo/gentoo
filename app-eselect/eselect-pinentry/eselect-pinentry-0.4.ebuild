# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-eselect/eselect-pinentry/eselect-pinentry-0.4.ebuild,v 1.1 2015/03/31 16:54:08 ulm Exp $

EAPI=5

DESCRIPTION="Manage /usr/bin/pinentry symlink"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=app-eselect/eselect-lib-bin-symlink-0.1.1"

S=${FILESDIR}

src_install() {
	insinto /usr/share/eselect/modules
	newins pinentry.eselect-${PV} pinentry.eselect
}
