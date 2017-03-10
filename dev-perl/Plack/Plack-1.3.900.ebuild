# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=1.0039
inherit perl-module

DESCRIPTION="Perl Superglue for Web frameworks and Web Servers (PSGI toolkit)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test minimal examples"
PATCHES=(
	"${FILESDIR}/${P}-issue-545.patch"
	"${FILESDIR}/${P}-network-testing.patch"
)
RDEPEND="
	!minimal? (
		dev-perl/CGI-Compile
		dev-perl/CGI-Emulate-PSGI
		dev-perl/FCGI
		dev-perl/FCGI-ProcManager
		>=dev-perl/libwww-perl-5.814.0
	)
	>=dev-perl/Apache-LogFormat-Compiler-0.120.0
	>=dev-perl/Cookie-Baker-0.50.0
	>=dev-perl/Devel-StackTrace-1.230.0
	>=dev-perl/Devel-StackTrace-AsHTML-0.110.0
	>=dev-perl/File-ShareDir-1.0.0
	dev-perl/Filesys-Notify-Simple
	>=dev-perl/HTTP-Body-1.60.0
	>=dev-perl/HTTP-Headers-Fast-0.180.0
	>=dev-perl/HTTP-Message-5.814.0
	>=virtual/perl-HTTP-Tiny-0.34.0
	>=dev-perl/Hash-MultiValue-0.50.0
	>=virtual/perl-Pod-Parser-1.360.0
	>=dev-perl/Stream-Buffered-0.20.0
	>=dev-perl/Test-TCP-2.0.0
	dev-perl/Try-Tiny
	>=dev-perl/URI-1.590.0
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
			dev-perl/IO-Handle-Util
			dev-perl/Log-Dispatch
			dev-perl/Log-Dispatch-Array
			dev-perl/Log-Log4perl
			dev-perl/LWP-Protocol-http10
			dev-perl/MIME-Types
			dev-perl/Module-Refresh
		)
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
	)
"
src_test() {
	perl_rm_files "t/author-pod-syntax.t"
	perl-module_src_test
}
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples/
		dodoc -r eg/dot-psgi/*
	fi
}
