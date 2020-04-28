# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="APEIRON"
MODULE_VERSION=0.79
inherit perl-module

DESCRIPTION="Perl IRC module"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ~arm ~arm64 ~mips ppc x86"
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
