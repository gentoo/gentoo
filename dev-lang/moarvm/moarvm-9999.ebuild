# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3

MY_PN="MoarVM"

DESCRIPTION="A 6model-based VM for NQP and Rakudo Perl 6"
HOMEPAGE="https://github.com/MoarVM/MoarVM"
EGIT_REPO_URI="https://github.com/MoarVM/MoarVM.git"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}/Configure-9999.patch" || die
}

src_configure() {
	 # this is quite badong, but wtf build system
	echo "2013.10-145-gec52026" >> VERSION
	perl Configure.pl --prefix="${D}/usr"|| die
}

src_install() {
	make install
}
