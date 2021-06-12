# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SJQUINNEY
DIST_VERSION=0.14
DIST_EXAMPLES=("example.pl")
inherit perl-module

DESCRIPTION="Serve static files with HTTP::Server::Simple"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/CGI-3.460.0
	virtual/perl-Exporter
	dev-perl/File-LibMagic
	virtual/perl-File-Spec
	dev-perl/HTTP-Date
	>=dev-perl/HTTP-Server-Simple-0.10.0
	virtual/perl-IO
	dev-perl/URI
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
"
