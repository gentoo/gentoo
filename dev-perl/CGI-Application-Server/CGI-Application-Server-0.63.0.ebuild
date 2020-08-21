# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RJBS
DIST_VERSION=0.063
inherit perl-module

DESCRIPTION="a simple HTTP server for developing with CGI::Application"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/CGI
	>=dev-perl/CGI-Application-4.210.0
	>=virtual/perl-Carp-0.10.0
	dev-perl/HTTP-Message
	>=dev-perl/HTTP-Server-Simple-0.180.0
	>=dev-perl/HTTP-Server-Simple-Static-0.20.0
	>=virtual/perl-Scalar-List-Utils-1.180.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/CGI-Application-Dispatch
		dev-perl/CGI-Application-Plugin-Redirect
		virtual/perl-File-Temp
		dev-perl/Test-Exception
		dev-perl/Test-HTTP-Server-Simple
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-WWW-Mechanize
	)
"
