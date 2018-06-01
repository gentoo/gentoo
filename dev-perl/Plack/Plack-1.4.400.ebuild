# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=1.0044
DIST_EXAMPLES=("eg/dot-psgi/*")
inherit perl-module

DESCRIPTION="Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test minimal examples"
PATCHES=(
	"${FILESDIR}/${PN}-1.3.900-network-testing.patch"
)
RDEPEND="
	!minimal? (
		dev-perl/CGI-Compile
		dev-perl/CGI-Emulate-PSGI
		dev-perl/FCGI
		dev-perl/FCGI-ProcManager
		>=dev-perl/libwww-perl-5.814.0
		>=dev-perl/Log-Dispatch-2.250.0
		dev-perl/Log-Log4perl
		dev-perl/Module-Refresh
	)
	>=dev-perl/Apache-LogFormat-Compiler-0.330.0
	>=dev-perl/Cookie-Baker-0.70.0
	>=dev-perl/Devel-StackTrace-1.230.0
	>=dev-perl/Devel-StackTrace-AsHTML-0.110.0
	>=dev-perl/File-ShareDir-1.0.0
	dev-perl/Filesys-Notify-Simple
	>=dev-perl/HTTP-Entity-Parser-0.170.0
	>=dev-perl/HTTP-Headers-Fast-0.180.0
	>=dev-perl/HTTP-Message-5.814.0
	>=virtual/perl-HTTP-Tiny-0.34.0
	>=dev-perl/Hash-MultiValue-0.50.0
	>=virtual/perl-Pod-Parser-1.360.0
	>=dev-perl/Stream-Buffered-0.20.0
	>=dev-perl/Test-TCP-2.150.0
	dev-perl/Try-Tiny
	>=dev-perl/URI-1.590.0
	>=dev-perl/WWW-Form-UrlEncoded-0.230.0
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		!minimal? (
			dev-perl/Authen-Simple-Passwd
			dev-perl/HTTP-Request-AsCGI
			dev-perl/HTTP-Server-Simple-PSGI
			dev-perl/Log-Dispatch-Array
			dev-perl/LWP-Protocol-http10
			dev-perl/MIME-Types
			>=dev-perl/Test-MockTime-HiRes-0.60.0
		)
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"
src_test() {
	perl_rm_files "t/author-pod-syntax.t"
	perl-module_src_test
}
