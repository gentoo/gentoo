# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OALDERS
DIST_VERSION=6.07
inherit perl-module

DESCRIPTION="Provide https support for LWP::UserAgent"

SLOT="0"
IUSE="test"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	app-misc/ca-certificates
	>=dev-perl/IO-Socket-SSL-1.540.0
	>=dev-perl/libwww-perl-6.60.0
	>=dev-perl/Net-HTTP-6
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-RequiresInternet
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.70.0-etcsslcerts.patch
	"${FILESDIR}"/${PN}-6.70.0-CVE-2014-3230.patch # note: breaks a test, still needed?
)
PERL_RM_FILES=(
	"t/https_proxy.t" # see above
)
