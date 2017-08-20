# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OALDERS
DIST_VERSION=1.84
inherit perl-module

DESCRIPTION="Handy web browsing in a Perl object"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Getopt-Long
	dev-perl/HTML-Form
	>=dev-perl/HTML-Parser-3.340.0
	dev-perl/HTML-Tree
	dev-perl/HTTP-Cookies
	dev-perl/HTTP-Message
	>=dev-perl/libwww-perl-5.827.0
	virtual/perl-Tie-RefHash
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
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		dev-perl/Test-Output
		dev-perl/Test-RequiresInternet
		virtual/perl-Test-Simple
		dev-perl/Test-Warnings
	)
"

src_test() {
	perl_rm_files t/author-*.t
	perl-module_src_test
}
