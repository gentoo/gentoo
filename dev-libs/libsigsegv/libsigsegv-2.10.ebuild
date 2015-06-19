# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libsigsegv/libsigsegv-2.10.ebuild,v 1.11 2015/05/30 06:40:27 jmorgan Exp $

EAPI=2

DESCRIPTION="library for handling page faults in user mode"
HOMEPAGE="http://libsigsegv.sourceforge.net/"
SRC_URI="mirror://gnu/libsigsegv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

src_configure () {
	econf --enable-shared || die "Configure phase failed"
}

src_test () {
	if [[ ${FEATURES} = *sandbox* ]]
	then
		# skip tests as they will fail
		return 0
	fi
	emake check ||  die "Tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog* NEWS PORTING README
}
