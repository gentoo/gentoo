# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="(Deprecated) SSL support for Net::SMTP"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-libnet
	dev-perl/IO-Socket-SSL
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"

pkg_postinst() {
	elog "This package is deprecated by upstream as equivalent support for SSL and"
	elog "STARTTLS is available with Net::SMTP 2.35, found in:"
	elog "  >=virtual/perl-libnet-1.28 ( >=dev-lang/perl-5.20.0 )"
	elog "Subsequently, this package is only available for compatibility reasons, and"
	elog "should be avoided in new code."
}
