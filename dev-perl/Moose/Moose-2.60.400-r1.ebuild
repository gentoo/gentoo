# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Moose/Moose-2.60.400-r1.ebuild,v 1.5 2015/03/29 09:27:03 jer Exp $

EAPI=5

MODULE_AUTHOR=DOY
MODULE_VERSION=2.0604
inherit perl-module

DESCRIPTION="A postmodern object system for Perl 5"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 x86 ~x86-fbsd ~x64-macos"
IUSE="test"

CONFLICTS="
	!<=dev-perl/Catalyst-5.800.280
	!<=dev-perl/Devel-REPL-1.003008
	!<=dev-perl/Fey-0.360
	!<=dev-perl/Fey-ORM-0.420
	!<=dev-perl/File-ChangeNotify-0.150
	!<=dev-perl/KiokuDB-0.510.0
	!<=dev-perl/Markdent-0.160
	!<=dev-perl/Mason-2.180.0
	!<=dev-perl/MooseX-ABC-0.50.0
	!<=dev-perl/MooseX-Aliases-0.80
	!<=dev-perl/MooseX-AlwaysCoerce-0.130.0
	!<=dev-perl/MooseX-Attribute-Deflator-2.1.7
	!<=dev-perl/MooseX-Attribute-Dependent-1.1.0
	!<=dev-perl/MooseX-Attribute-Prototype-0.100
	!<=dev-perl/MooseX-AttributeHelpers-0.22
	!<=dev-perl/MooseX-AttributeIndexes-1.0.0
	!<=dev-perl/MooseX-AttributeInflate-0.20
	!<=dev-perl/MooseX-CascadeClearing-0.30.0
	!<=dev-perl/MooseX-ClassAttribute-0.250.0
	!<=dev-perl/MooseX-Meta-Attribute-Index-0.40.0
	!<=dev-perl/MooseX-Meta-Attribute-Lvalue-0.50.0
	!<=dev-perl/MooseX-Constructor-AllErrors-0.12
	!<=dev-perl/MooseX-FollowPBP-0.20
	!<=dev-perl/MooseX-HasDefaults-0.20
	!<=dev-perl/MooseX-InstanceTracking-0.40
	!<=dev-perl/MooseX-LazyRequire-0.60.0
	!<=dev-perl/MooseX-NonMoose-0.170.0
	!<=dev-perl/MooseX-POE-0.214.0
	!<=dev-perl/MooseX-Params-Validate-0.50
	!<=dev-perl/MooseX-PrivateSetters-0.30.0
	!<=dev-perl/MooseX-Role-Cmd-0.60
	!<=dev-perl/MooseX-Role-Parameterized-0.230.0
	!<=dev-perl/MooseX-Role-WithOverloading-0.070
	!<=dev-perl/MooseX-Scaffold-0.50.0
	!<=dev-perl/MooseX-SemiAffordanceAccessor-0.50
	!<=dev-perl/MooseX-SetOnce-0.100.472
	!<=dev-perl/MooseX-Singleton-0.250
	!<=dev-perl/MooseX-StrictConstructor-0.120
	!<=dev-perl/MooseX-Types-Parameterizable-0.50.0
	!<=dev-perl/MooseX-Types-Signal-1.101930
	!<=dev-perl/MooseX-Types-0.190
	!<=dev-perl/MooseX-UndefTolerant-0.110.0
	!<=dev-perl/PRANG-0.140.0
	!<=dev-perl/Pod-Elemental-0.93.280
	!<=dev-perl/Reaction-0.2.3
	!<=dev-perl/Test-Able-0.100.0
	!<=dev-perl/namespace-autoclean-0.08
"

RDEPEND="
	${CONFLICTS}
	!dev-perl/Class-MOP
	>=dev-perl/Class-Load-0.90.0
	>=dev-perl/Class-Load-XS-0.10.0
	>=dev-perl/Dist-CheckConflicts-0.20
	>=dev-perl/Data-OptList-0.107.0
	dev-perl/Devel-GlobalDestruction
	>=dev-perl/Eval-Closure-0.40.0
	>=dev-perl/List-MoreUtils-0.280.0
	>=dev-perl/MRO-Compat-0.05
	>=dev-perl/Package-DeprecationManager-0.110.0
	>=dev-perl/Package-Stash-0.320.0
	>=dev-perl/Package-Stash-XS-0.240.0
	>=dev-perl/Params-Util-1
	>=virtual/perl-Scalar-List-Utils-1.19
	>=dev-perl/Sub-Exporter-0.980
	>=dev-perl/Sub-Name-0.05
	>=dev-perl/Try-Tiny-0.20
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.56
	test? (
		dev-perl/PadWalker
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.88
		dev-perl/Test-Requires
		>=dev-perl/Test-Output-0.09
		>=dev-perl/Test-Warn-0.11
		dev-perl/Test-Deep
		dev-perl/Module-Refresh
	)"

PATCHES=( "${FILESDIR}"/${P}-cmop-package-stash.patch )

SRC_TEST="do parallel"

src_compile() {
	emake OPTIMIZE="${CFLAGS}"
}
