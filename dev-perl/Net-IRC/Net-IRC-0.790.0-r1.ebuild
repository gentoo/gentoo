# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-IRC/Net-IRC-0.790.0-r1.ebuild,v 1.2 2013/12/09 19:24:54 zlogene Exp $

EAPI=5

MODULE_AUTHOR="APEIRON"
MODULE_VERSION=0.79
inherit perl-module

DESCRIPTION="Perl IRC module"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~arm ~mips ppc x86"
IUSE=""

SRC_TEST="do"

mydoc="TODO"

src_prepare() {
	# Remove the stdin and warning input required re deprecated.
	sed -i \
		-e '/or die $warning/d' \
		-e '/my $acceptance/,/$acceptance eq $ok/d' \
		"${S}"/Makefile.PL || die "sed failed"
	perl-module_src_prepare
}
