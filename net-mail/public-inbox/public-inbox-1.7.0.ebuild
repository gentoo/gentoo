# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

HOMEPAGE="https://public-inbox.org"
SRC_URI="https://public-inbox.org/public-inbox.git/snapshot/${P}.tar.gz"
DESCRIPTION="An archives-first approach to mailing lists"
LICENSE="AGPL-3+"

SLOT="0"

KEYWORDS="~amd64"

# in order of mention in INSTALL.html, going more for feature completeness
# than for minimal footprint
RDEPEND="
	dev-vcs/git
	dev-perl/DBD-SQLite
	virtual/mta
	dev-perl/URI
	dev-perl/Plack
	dev-perl/TimeDate
	dev-perl/Inline-C
	dev-perl/Email-Address-XS
	dev-perl/Search-Xapian
	dev-perl/Parse-RecDescent
	dev-perl/Mail-IMAPClient
	dev-perl/BSD-Resource
	net-misc/curl
	dev-perl/Linux-Inotify2
	dev-perl/Net-Server
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
