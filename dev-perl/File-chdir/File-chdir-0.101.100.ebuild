# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.1011
inherit perl-module

DESCRIPTION="An alternative to File::Spec and CWD"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=virtual/perl-File-Spec-3.27
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? ( virtual/perl-Test-Simple )
"
