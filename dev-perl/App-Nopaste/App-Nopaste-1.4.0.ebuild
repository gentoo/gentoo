# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/App-Nopaste/App-Nopaste-1.4.0.ebuild,v 1.3 2015/06/13 18:47:08 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.004
inherit perl-module

DESCRIPTION="Easy access to any pastebin"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="+pastebin clipboard github test"

RDEPEND="
	dev-perl/Class-Load
	virtual/perl-Exporter
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/Getopt-Long-Descriptive
	dev-perl/JSON
	dev-perl/Module-Pluggable
	dev-perl/Module-Runtime
	dev-perl/URI
	dev-perl/WWW-Mechanize
	dev-perl/namespace-clean
	pastebin? (
		>=dev-perl/WWW-Pastebin-PastebinCom-Create-1.3.0
	)
	clipboard? (
		dev-perl/Clipboard
	)
	github? (
		dev-vcs/git[perl]
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/libwww-perl
		dev-perl/Test-Deep
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do"
