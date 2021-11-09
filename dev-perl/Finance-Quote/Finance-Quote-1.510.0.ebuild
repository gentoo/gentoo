# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPSCHUCK
DIST_VERSION=1.51
DIST_EXAMPLES=( "Examples/*" )
inherit perl-module

DESCRIPTION="Get stock and mutual fund quotes from various exchanges"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-perl/CGI
	virtual/perl-Carp
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	virtual/perl-Encode
	virtual/perl-Exporter
	dev-perl/HTML-TableExtract
	dev-perl/HTML-Parser
	dev-perl/HTML-TokeParser-Simple
	dev-perl/HTML-Tree
	dev-perl/HTTP-Cookies
	dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/JSON-Parse
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	virtual/perl-Module-Load
	dev-perl/Mozilla-CA
	virtual/perl-Scalar-List-Utils
	dev-perl/Spreadsheet-XLSX
	dev-perl/String-Util
	dev-perl/Text-Template
	virtual/perl-Time-Piece
	dev-perl/Try-Tiny
	dev-perl/URI
	dev-perl/Web-Scraper
	dev-perl/XML-LibXML
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		dev-perl/Date-Manip
		dev-perl/Date-Range
		dev-perl/Date-Simple
		dev-perl/DateTime-Format-ISO8601
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/01-pod.t
	t/02-pod-coverage.t
	t/03-kwalitee.t
	t/04-critic.t
	t/author-pod-syntax.t
	lib/GPATH
	lib/GRTAGS
	lib/GTAGS
)

src_test() {
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
