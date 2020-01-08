# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DWHEELER
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="Test routines for examining the contents of files"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Digest-MD5
	virtual/perl-File-Spec
	>=virtual/perl-Test-Simple-0.700.0
	>=dev-perl/Text-Diff-0.350.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.300.0
"
