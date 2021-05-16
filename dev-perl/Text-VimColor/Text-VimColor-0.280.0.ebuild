# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=0.28
DIST_AUTHOR=RWSTAUNER

inherit perl-module

DESCRIPTION="Syntax highlighting using vim"
HOMEPAGE="https://github.com/rwstauner/Text-VimColor"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-editors/vim[-minimal]
	virtual/perl-Carp
	dev-perl/File-ShareDir
	virtual/perl-File-Temp
	virtual/perl-Getopt-Long
	virtual/perl-IO
	>=dev-perl/Path-Class-0.40.0
	>=virtual/perl-Term-ANSIColor-1.30.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Spec
		dev-perl/Test-File-ShareDir
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/XML-Parser
	)
"
