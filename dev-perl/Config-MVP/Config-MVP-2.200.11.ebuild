# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=RJBS
DIST_VERSION=2.200011
inherit perl-module

DESCRIPTION="multivalue-property package-oriented configuration"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

# r: Module::Pluggable::Object -> Module-Pluggable
# r: Moose::Role -> Moose
# r: Moose::Util::TypeConstraints -> Moose
# r: Role::Identifiable::HasIdent -> Role-Identifiable
# r: StackTrace::Auto -> Throwable
# r: Test::More -> Test-Simple (Yes, Runtime)
# r: overload, string, warnings -> perl
RDEPEND="
	>=dev-perl/Class-Load-0.170.0
	virtual/perl-File-Spec
	dev-perl/Module-Pluggable
	>=dev-perl/Moose-0.910.0
	dev-perl/MooseX-OneArgNew
	dev-perl/Params-Util
	dev-perl/Role-HasMessage
	dev-perl/Role-Identifiable
	dev-perl/Throwable
	dev-perl/Tie-IxHash
	dev-perl/Try-Tiny
"
# t: lib -> perl
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
