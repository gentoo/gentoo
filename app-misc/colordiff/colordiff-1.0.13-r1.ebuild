# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/colordiff/colordiff-1.0.13-r1.ebuild,v 1.8 2015/02/12 13:40:10 armin76 Exp $

EAPI=5

inherit prefix

DESCRIPTION="Colorizes output of diff"
HOMEPAGE="http://www.colordiff.org/"
SRC_URI="http://www.colordiff.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~x86-fbsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	dev-lang/perl
	sys-apps/diffutils"

src_prepare() {
	# set proper etcdir for Gentoo Prefix
	sed \
		-e "s:'/etc:'@GENTOO_PORTAGE_EPREFIX@/etc:" \
		-i "${S}/colordiff.pl" || die "sed etcdir failed"
	eprefixify "${S}"/colordiff.pl
}

# This package has a makefile, but we don't want to run it
src_compile() { :; }

src_install() {
	newbin ${PN}{.pl,}
	dobin cdiff.sh
	insinto /etc
	doins colordiffrc colordiffrc-lightbg
	dodoc BUGS CHANGES README
	doman {cdiff,colordiff}.1
}
