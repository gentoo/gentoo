# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lsb-release/lsb-release-1.4-r1.ebuild,v 1.1 2014/06/04 23:25:53 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="LSB version query program"
HOMEPAGE="http://www.linuxfoundation.org/collaborate/workgroups/lsb"
SRC_URI="mirror://sourceforge/lsb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

# Perl isn't needed at runtime, it is just used to generate the man page.
DEPEND="dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}"/${P}-os-release.patch # bug 443116
}

src_install() {
	emake \
		prefix="${D}/usr" \
		mandir="${D}/usr/share/man" \
		install

	dodir /etc
	cat > "${D}/etc/lsb-release" <<- EOF
		DISTRIB_ID="Gentoo"
	EOF
}
