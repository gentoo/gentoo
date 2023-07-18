# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=3.010
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Mail folder manager and MUA backend"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

PDEPEND="
	dev-perl/Mail-Box-IMAP4
	dev-perl/Mail-Box-POP3
"
RDEPEND="
	virtual/perl-Carp
	dev-perl/TimeDate
	>=dev-perl/Devel-GlobalDestruction-0.90.0
	>=dev-perl/File-Remove-0.200.0
	>=virtual/perl-File-Spec-0.700.0
	dev-perl/IO-stringy
	>=dev-perl/Mail-Message-3.13.0
	>=dev-perl/Mail-Transport-3.3.0
	>=dev-perl/Object-Realize-Later-0.190.0
	>=virtual/perl-Scalar-List-Utils-1.130.0
	!!<dev-perl/Mail-Box-3
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
