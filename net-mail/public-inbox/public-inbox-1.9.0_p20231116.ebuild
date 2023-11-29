# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="An archives-first approach to mailing lists"
HOMEPAGE="https://public-inbox.org"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="
		https://public-inbox.org/public-inbox.git/
		https://repo.or.cz/public-inbox.git
	"
	inherit git-r3
elif [[ ${PV} == *_p* ]] ; then
	PUBLIC_INBOX_COMMIT="9005cb3dced86b78715fef0472a83813003e8e0d"
	SRC_URI="https://public-inbox.org/public-inbox.git/snapshot/${PUBLIC_INBOX_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PUBLIC_INBOX_COMMIT}
else
	SRC_URI="https://public-inbox.org/public-inbox.git/snapshot/${P}.tar.gz"
fi

LICENSE="AGPL-3+"
SLOT="0"
if [[ ${PV} != 9999 ]] ; then
	KEYWORDS="~amd64"
fi

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
