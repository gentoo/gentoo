# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="Colorizes output of diff"
HOMEPAGE="https://www.colordiff.org/"
SRC_URI="https://www.colordiff.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~sparc x86 ~x64-macos"

RDEPEND="
	dev-lang/perl
	sys-apps/diffutils
"

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
