# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.666005
inherit perl-module

DESCRIPTION="Polymorphic Return Values"

SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
pkg_postinst() {
	elog "This package has been marked as deprecated by upstream, and it is advisable you"
	elog "migrate existing code that needs this."
}
