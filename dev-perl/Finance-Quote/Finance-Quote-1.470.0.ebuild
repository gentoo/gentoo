# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ECOCODE
DIST_VERSION=1.47
DIST_EXAMPLES=( "Examples/*" )
inherit perl-module

DESCRIPTION="Get stock and mutual fund quotes from various exchanges"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 x86"
IUSE="test"

# virtual/perl-Data-Dumper currently commented out in the code

RDEPEND="
	dev-perl/CGI
	virtual/perl-Carp
	dev-perl/DateTime
	virtual/perl-Encode
	virtual/perl-Exporter
	dev-perl/HTML-Parser
	dev-perl/HTML-TableExtract
	dev-perl/HTML-Tree
	dev-perl/HTTP-Cookies
	dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/Mozilla-CA
	virtual/perl-Time-Piece
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/01-pod.t t/02-pod-coverage.t t/03-kwalitee.t \
		t/04-critic.t t/author-pod-syntax.t
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		einfo "Disabling network tests without DIST_TEST_OVERRIDE=~network"
	else
		export ONLINE_TEST=1
	fi
	perl-module_src_test
}

mydoc=("Documentation/*")

src_install() {
	dodoc -r htdocs
	perl-module_src_install
}
