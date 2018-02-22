# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OALDERS
DIST_VERSION=6.27
inherit perl-module

DESCRIPTION="A collection of Perl Modules for the WWW"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="ssl test"

RDEPEND="
	virtual/perl-Digest-MD5
	>=virtual/perl-Encode-2.120.0
	dev-perl/Encode-Locale
	>=dev-perl/File-Listing-6.0.0
	>=dev-perl/HTML-Parser-3.340.0
	>=dev-perl/HTTP-Cookies-6.0.0
	>=dev-perl/HTTP-Daemon-6.0.0
	>=dev-perl/HTTP-Date-6.0.0
	>=dev-perl/HTTP-Negotiate-6.0.0
	>=dev-perl/HTTP-Message-6.0.0
	virtual/perl-IO
	>=dev-perl/LWP-MediaTypes-6.0.0
	>=virtual/perl-MIME-Base64-2.120.0
	>=dev-perl/Net-HTTP-6.70.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Try-Tiny
	>=dev-perl/URI-1.100.0
	>=dev-perl/WWW-RobotRules-6.0.0
	>=virtual/perl-libnet-1.220.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Getopt-Long
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		dev-perl/Test-RequiresInternet
		virtual/perl-Test-Simple
	)
"
PDEPEND="
	ssl? (
		>=dev-perl/LWP-Protocol-https-6.20.0
	)
"

src_install() {
	perl-module_src_install

	# Perform a check to see if the live filesystem is case-INsensitive
	# or not.  If it is, the symlinks GET, POST and in particular HEAD
	# will collide with e.g. head from coreutils.  While under Linux
	# having a case-INsensitive filesystem is really unusual, most Mac
	# OS X users are on it, and also Interix users deal with
	# case-INsensitivity since Windows is underneath.

	# bash should always be there, if we can find it in capitals, we're
	# on a case-INsensitive filesystem.
	if [[ ! -f ${EROOT}/BIN/BASH ]] ; then
		dosym lwp-request /usr/bin/GET
		dosym lwp-request /usr/bin/POST
		dosym lwp-request /usr/bin/HEAD
	fi
}
