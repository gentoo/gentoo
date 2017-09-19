# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MONSIEURP
DIST_VERSION=0.004000

inherit perl-module

DESCRIPTION="Readily merge Pull Requests from the Gentoo Github repository"
HOMEPAGE="https://github.com/monsieurp/Gentoo-App-Pram"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Encode
	virtual/perl-File-Temp
	dev-perl/File-Which
	dev-vcs/git
	virtual/perl-Getopt-Long
	virtual/perl-HTTP-Tiny
	>=dev-perl/IO-Socket-SSL-1.560.0
	>=dev-perl/Net-SSLeay-1.490.0
	virtual/perl-Term-ANSIColor
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=virtual/perl-Test-Simple-0.890.0
	)
"
