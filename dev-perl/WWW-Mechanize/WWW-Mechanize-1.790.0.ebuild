# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=OALDERS
DIST_VERSION=1.79
inherit perl-module

DESCRIPTION="Handy web browsing in a Perl object"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Getopt-Long
	dev-perl/HTML-Form
	>=dev-perl/HTML-Parser-3.340.0
	dev-perl/HTML-Tree
	dev-perl/HTTP-Cookies
	dev-perl/HTTP-Message
	dev-perl/libwww-perl
	>=dev-perl/URI-1.360.0
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/CGI-4.320.0
		virtual/perl-Encode
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/HTTP-Daemon
		dev-perl/HTTP-Server-Simple
		virtual/perl-Test-Simple
		dev-perl/Test-Output
		dev-perl/Test-RequiresInternet
	)
"

# MI makes these configure problems
src_prepare() {
	use test && perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_prepare
}
