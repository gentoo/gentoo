# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RYBSKEJ
DIST_VERSION=0.36
inherit perl-module

DESCRIPTION="Emulate threads with fork"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Acme-Damn
	virtual/perl-Attribute-Handlers
	dev-perl/Devel-Symdump
	virtual/perl-File-Spec
	>=dev-perl/List-MoreUtils-0.150.0
	>=virtual/perl-Scalar-List-Utils-1.110.0
	virtual/perl-Storable
	>=dev-perl/Sys-SigAction-0.110.0
	virtual/perl-Time-HiRes
	virtual/perl-if
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
