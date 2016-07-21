# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=2.1605
inherit perl-module

DESCRIPTION="A postmodern object system for Perl 5"

SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~x64-macos"
IUSE="test"

CONFLICTS="
	!<=dev-perl/Catalyst-5.900.499.990
	!<=dev-perl/Config-MVP-2.200.4
	!<=dev-perl/Devel-REPL-1.3.20
	!<=dev-perl/Dist-Zilla-Plugin-Git-2.16.0
	!<=dev-perl/Fey-0.360.0
	!<=dev-perl/Fey-ORM-0.420.0
	!<=dev-perl/File-ChangeNotify-0.150.0
	!<=dev-perl/HTTP-Throwable-0.17.0
	!<=dev-perl/KiokuDB-0.510.0
	!<=dev-perl/Markdent-0.160.0
	!<=dev-perl/Mason-2.180.0
	!<=dev-perl/MooseX-ABC-0.50.0
	!<=dev-perl/MooseX-Aliases-0.80.0
	!<=dev-perl/MooseX-AlwaysCoerce-0.130.0
	!<=dev-perl/MooseX-App-1.220.0
	!<=dev-perl/MooseX-Attribute-Deflator-2.1.7
	!<=dev-perl/MooseX-Attribute-Dependent-1.1.0
	!<=dev-perl/MooseX-Attribute-Prototype-0.100.0
	!<=dev-perl/MooseX-AttributeHelpers-0.220.0
	!<=dev-perl/MooseX-AttributeIndexes-1.0.0
	!<=dev-perl/MooseX-AttributeInflate-0.20.0
	!<=dev-perl/MooseX-CascadeClearing-0.30.0
	!<=dev-perl/MooseX-ClassAttribute-0.260.0
	!<=dev-perl/MooseX-Constructor-AllErrors-0.21.0
	!<=dev-perl/MooseX-Declare-0.350.0
	!<=dev-perl/MooseX-FollowPBP-0.20.0
	!<=dev-perl/MooseX-Getopt-0.560.0
	!<=dev-perl/MooseX-InstanceTracking-0.40.0
	!<=dev-perl/MooseX-LazyRequire-0.60.0
	!<=dev-perl/MooseX-Meta-Attribute-Index-0.40.0
	!<=dev-perl/MooseX-Meta-Attribute-Lvalue-0.50.0
	!<=dev-perl/MooseX-Method-Signatures-0.440.0
	!<=dev-perl/MooseX-MethodAttributes-0.220.0
	!<=dev-perl/MooseX-NonMoose-0.240.0
	!<=dev-perl/MooseX-Object-Pluggable-0.1.100
	!<=dev-perl/MooseX-POE-0.214.0
	!<=dev-perl/MooseX-Params-Validate-0.50.0
	!<=dev-perl/MooseX-PrivateSetters-0.30.0
	!<=dev-perl/MooseX-Role-Cmd-0.60.0
	!<=dev-perl/MooseX-Role-Parameterized-1.0.0
	!<=dev-perl/MooseX-Role-WithOverloading-0.140.0
	!<=dev-perl/MooseX-Runnable-0.30.0
	!<=dev-perl/MooseX-Scaffold-0.50.0
	!<=dev-perl/MooseX-SemiAffordanceAccessor-0.50
	!<=dev-perl/MooseX-SetOnce-0.100.473
	!<=dev-perl/MooseX-Singleton-0.250.0
	!<=dev-perl/MooseX-SlurpyConstructor-1.100.0
	!<=dev-perl/MoooseX-Storage-0.420.0
	!<=dev-perl/MooseX-StrictConstructor-0.120.0
	!<=dev-perl/MooseX-Traits-0.110.0
	!<=dev-perl/MooseX-Types-0.190.0
	!<=dev-perl/MooseX-Types-Parameterizable-0.50.0
	!<=dev-perl/MooseX-Types-Set-Object-0.30.0
	!<=dev-perl/MooseX-Types-Signal-1.101.930
	!<=dev-perl/MooseX-UndefTolerant-0.110.0
	!<=dev-perl/PRANG-0.140.0
	!<=dev-perl/Pod-Elemental-0.93.280
	!<=dev-perl/Pod-Weaver-3.101.638
	!<=dev-perl/Reaction-0.2.3
	!<=dev-perl/Test-Able-0.100.0
	!<=dev-perl/Test-CleanNamespaces-0.30.0
	!<=dev-perl/Test-Moose-More-0.22.0
	!<=dev-perl/Test-TempDir-0.50.0
	!<=dev-perl/Throwable-0.102.80
	!<=dev-perl/namespace-autoclean-0.80.0
"

# r:List::Util, r:Scalar::Util -> Scalar-List-Utils
RDEPEND="
	${CONFLICTS}
	>=virtual/perl-Carp-1.220.0
	>=dev-perl/Class-Load-0.90.0
	>=dev-perl/Class-Load-XS-0.10.0
	>=dev-perl/Data-OptList-0.107.0
	dev-perl/Devel-GlobalDestruction
	>=dev-perl/Devel-OverloadInfo-0.4.0
	>=dev-perl/Devel-StackTrace-1.330.0
	>=dev-perl/Dist-CheckConflicts-0.20.0
	>=dev-perl/Eval-Closure-0.40.0
	>=virtual/perl-JSON-PP-2.273.0
	>=dev-perl/List-MoreUtils-0.280.0
	>=dev-perl/MRO-Compat-0.50.0
	>=dev-perl/Module-Runtime-0.14.0
	>=dev-perl/Module-Runtime-Conflicts-0.2.0
	>=dev-perl/Package-DeprecationManager-0.110.0
	>=dev-perl/Package-Stash-0.320.0
	>=dev-perl/Package-Stash-XS-0.240.0
	>=dev-perl/Params-Util-1.0.0
	>=virtual/perl-Scalar-List-Utils-1.350.0
	>=dev-perl/Sub-Exporter-0.980.0
	dev-perl/Sub-Identify
	>=dev-perl/Sub-Name-0.50.0
	dev-perl/Task-Weaken
	>=dev-perl/Try-Tiny-0.170.0
	>=virtual/perl-parent-0.223.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	virtual/perl-File-Spec
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-CPAN-Meta-Requirements
		>=dev-perl/Test-CleanNamespaces-0.130.0
		>=dev-perl/Test-Fatal-0.1.0
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-Requires-0.50.0
		>=dev-perl/Test-Warnings-0.16.0
	)
"
