# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=OALDERS
DIST_VERSION=0.0945
DIST_EXAMPLES=("anonymize-archives");
inherit perl-module

DESCRIPTION="Single interface to deal with file archives"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Archive-Tar
	dev-perl/Archive-Zip
	dev-perl/Module-Find
	dev-perl/MIME-Types
	dev-perl/File-MMagic
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"
