# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="An archives-first approach to mailing lists"
HOMEPAGE="https://public-inbox.org"
SRC_URI="https://public-inbox.org/public-inbox.git/snapshot/${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

# in order of mention in INSTALL.html, going more for feature completeness
# than for minimal footprint
RDEPEND="
	dev-perl/BSD-Resource
	dev-perl/DBD-SQLite
	dev-perl/Email-Address-XS
	dev-perl/Inline-C
	dev-perl/Linux-Inotify2
	dev-perl/Mail-IMAPClient
	dev-perl/Net-Server
	dev-perl/Parse-RecDescent
	dev-perl/Plack
	dev-perl/Search-Xapian
	dev-perl/TimeDate
	dev-perl/URI
	dev-vcs/git
	net-misc/curl
	virtual/mta
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
