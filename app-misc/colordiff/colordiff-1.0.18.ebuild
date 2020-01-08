# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit prefix

DESCRIPTION="Colorizes output of diff"
HOMEPAGE="https://www.colordiff.org/"
SRC_URI="https://www.colordiff.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	dev-lang/perl
	sys-apps/diffutils"

src_prepare() {
	default

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
	doins colordiffrc{,-lightbg,-gitdiff}
	dodoc BUGS CHANGES README
	doman {cdiff,colordiff}.1
}
