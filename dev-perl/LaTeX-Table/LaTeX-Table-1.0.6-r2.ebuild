# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LIMAONE
DIST_VERSION=v${PV}
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl extension for the automatic generation of LaTeX tables"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Module-Pluggable
	dev-perl/Moose
	dev-perl/MooseX-FollowPBP
	virtual/perl-Scalar-List-Utils
	dev-perl/Template-Toolkit
	virtual/perl-version
"
BDEPEND="${RDEPEND}
	virtual/perl-File-Spec
	dev-perl/Module-Build
	test? ( dev-perl/Test-NoWarnings )
"
