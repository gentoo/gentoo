# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OALDERS
DIST_VERSION=0.0946
DIST_EXAMPLES=("anonymize-archives");
inherit perl-module

DESCRIPTION="Single interface to deal with file archives"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Archive-Tar
	dev-perl/Archive-Zip
	dev-perl/File-MMagic
	virtual/perl-File-Spec
	dev-perl/Module-Find
	dev-perl/MIME-Types
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"
