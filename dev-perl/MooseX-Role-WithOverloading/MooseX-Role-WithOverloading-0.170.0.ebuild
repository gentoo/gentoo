# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Roles which support overloading (DEPRECATED)"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/Moose-0.940.0
	dev-perl/aliased
	>=dev-perl/namespace-autoclean-0.160.0
	>=dev-perl/namespace-clean-0.190.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-if
	)
"
pkg_postinst() {
	ewarn "dev-perl/MooseX-Role-WithOverloading is deprecated by upstream as"
	ewarn "equivalent functionality is now provided by >=dev-perl/Moose-2.130.0"
}
