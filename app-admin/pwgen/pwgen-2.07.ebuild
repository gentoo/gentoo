# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pwgen/pwgen-2.07.ebuild,v 1.10 2015/04/23 06:16:07 jlec Exp $

EAPI=5

inherit eutils

DESCRIPTION="Password Generator"
HOMEPAGE="http://sourceforge.net/projects/pwgen/"
SRC_URI="mirror://sourceforge/pwgen/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="livecd"

src_prepare() {
	epatch "${FILESDIR}"/2.06-special-char.patch
}

src_configure() {
	econf --sysconfdir="${EPREFIX}"/etc/pwgen
}

src_install() {
	default
	use livecd && newinitd "${FILESDIR}"/pwgen.rc pwgen
}
