# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MONSIEURP
DIST_VERSION=0.200000

inherit perl-module

DESCRIPTION="Utility to merge PRs from the Gentoo Github repository"
HOMEPAGE="https://github.com/monsieurp/Gentoo-App-Pram"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	dev-vcs/git
	virtual/perl-Encode
	dev-perl/File-Which
	dev-perl/Net-SSLeay
	dev-perl/IO-Socket-SSL
	virtual/perl-File-Temp
	virtual/perl-HTTP-Tiny
	virtual/perl-Getopt-Long
	virtual/perl-Term-ANSIColor"

DEPEND="
	${RDEPEND}
	dev-perl/Module-Build-Tiny
	test? (
		virtual/perl-Test-Simple
	)"
