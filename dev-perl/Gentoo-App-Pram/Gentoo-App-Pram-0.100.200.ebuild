# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MONSIEURP
DIST_VERSION=0.100200

inherit perl-module

DESCRIPTION="Utility to merge PRs from the Gentoo Github repository"
HOMEPAGE="https://github.com/monsieurp/Gentoo-App-Pram"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	dev-vcs/git
	virtual/perl-Encode
	dev-perl/File-Which
	virtual/perl-File-Temp
	virtual/perl-HTTP-Tiny
	virtual/perl-Getopt-Long
	virtual/perl-Term-ANSIColor
	>=dev-perl/Net-SSLeay-1.490.0
	>=dev-perl/IO-Socket-SSL-1.560.0"

DEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=virtual/perl-Test-Simple-0.890.0
	)"
