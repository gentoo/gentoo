# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=1.013
inherit perl-module

DESCRIPTION="Easy access to any pastebin"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="+pastebin +browser clipboard gitlab test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Class-Load
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/Getopt-Long-Descriptive
	dev-perl/JSON-MaybeXS
	dev-perl/libwww-perl
	dev-perl/Module-Pluggable
	dev-perl/Module-Runtime
	dev-perl/Path-Tiny
	dev-perl/URI
	dev-perl/WWW-Mechanize
	>=dev-perl/namespace-clean-0.190.0
	pastebin? (
		>=dev-perl/WWW-Pastebin-PastebinCom-Create-1.3.0
	)
	clipboard? (
		dev-perl/Clipboard
	)
	gitlab? (
		dev-vcs/git
	)
	browser? (
		dev-perl/Browser-Open
	)
"
BDEPEND="${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
