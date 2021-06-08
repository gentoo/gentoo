# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ECOCODE
DIST_VERSION=1.49
DIST_EXAMPLES=( "Examples/*" )
inherit perl-module

DESCRIPTION="Get stock and mutual fund quotes from various exchanges"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/CGI
	virtual/perl-Carp
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	virtual/perl-Encode
	virtual/perl-Exporter
	virtual/perl-File-Temp
	dev-perl/HTML-Parser
	dev-perl/HTML-TableExtract
	dev-perl/HTML-Tree
	dev-perl/HTTP-Cookies
	dev-perl/HTTP-Message
	dev-perl/JSON
	dev-perl/JSON-Parse
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/Mozilla-CA
	virtual/perl-Scalar-List-Utils
	dev-perl/String-Util
	dev-perl/Text-Template
	virtual/perl-Time-Piece
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
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
