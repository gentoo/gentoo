# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/convmv/convmv-1.15.ebuild,v 1.3 2014/09/09 09:36:02 polynomial-c Exp $

EAPI=3

inherit eutils

DESCRIPTION="convert filenames to utf8 or any other charset"
HOMEPAGE="http://j3e.de/linux/convmv"
SRC_URI="http://j3e.de/linux/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "1s|#!/usr|#!${EPREFIX}/usr|" convmv || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install \
		|| die "einstall failed"
	dodoc CREDITS Changes TODO VERSION
}

src_test() {
	unpack ./testsuite.tar

	cd "${S}"/suite
	./dotests.sh || die "Tests failed"
}
