# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPSCHUCK
DIST_VERSION=1.67
DIST_EXAMPLES=( "Examples/*" )
inherit perl-module

DESCRIPTION="Get stock and mutual fund quotes from various exchanges"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~ppc64 ~riscv x86"

RDEPEND="
	dev-perl/CGI
	dev-perl/DateTime
	dev-perl/DateTime-Format-Strptime
	dev-perl/HTML-TableExtract
	dev-perl/HTML-Parser
	dev-perl/HTML-Tree
	dev-perl/HTTP-Cookies
	>=dev-perl/HTTP-CookieJar-0.14.0
	dev-perl/HTTP-Message
	dev-perl/IO-String
	dev-perl/JSON
	dev-perl/JSON-Parse
	dev-perl/LWP-Protocol-https
	dev-perl/libwww-perl
	dev-perl/Mozilla-CA
	>=dev-perl/Net-SSLeay-1.920.0
	dev-perl/Readonly
	dev-perl/Spreadsheet-XLSX
	dev-perl/String-Util
	dev-perl/Text-Template
	dev-perl/TimeDate
	>=dev-perl/URI-3.310.0
	dev-perl/Web-Scraper
	dev-perl/XML-LibXML
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Date-Manip
		dev-perl/Date-Range
		dev-perl/Date-Simple
		dev-perl/DateTime-Format-ISO8601
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

mydoc=("Documentation/*")

src_test() {
	if ! has network ${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}; then
		einfo "Disabling network tests without DIST_TEST_OVERRIDE=~network"
	else
		export ONLINE_TEST=1
	fi
	perl-module_src_test
}

src_install() {
	dodoc -r htdocs
	perl-module_src_install
}
