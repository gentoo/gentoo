# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=6.81
inherit perl-module

DESCRIPTION="Collection of Perl Modules for the WWW"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"
IUSE="ssl"

RDEPEND="
	dev-perl/Encode-Locale
	>=dev-perl/File-Listing-6.0.0
	>=dev-perl/HTML-Parser-3.710.0
	>=dev-perl/HTTP-Cookies-6.0.0
	>=dev-perl/HTTP-Date-6.0.0
	>=dev-perl/HTTP-Negotiate-6.0.0
	>=dev-perl/HTTP-Message-6.180.0
	>=dev-perl/LWP-MediaTypes-6.0.0
	>=dev-perl/Net-HTTP-6.180.0
	dev-perl/Try-Tiny
	>=dev-perl/URI-1.100.0
	>=dev-perl/WWW-RobotRules-6.0.0
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/HTTP-CookieJar
		>=dev-perl/HTTP-Daemon-6.120.0
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		dev-perl/Test-RequiresInternet
	)
"
PDEPEND="
	ssl? (
		>=dev-perl/LWP-Protocol-https-6.20.0
	)
"

pkg_postinst() {
	# Perform a check to see if the live filesystem is case-INsensitive
	# or not.  If it is, the symlinks GET, POST and in particular HEAD
	# will collide with e.g. head from coreutils.  While under Linux
	# having a case-INsensitive filesystem is really unusual, most Mac
	# OS X users are on it, and also Interix users deal with
	# case-INsensitivity since Windows is underneath.

	# bash should always be there, if we can find it in capitals, we're
	# on a case-INsensitive filesystem.
	if [[ ! -f ${EROOT}/BIN/BASH ]] ; then
		ln -s lwp-request "${EROOT}"/usr/bin/GET
		ln -s lwp-request "${EROOT}"/usr/bin/POST
		ln -s lwp-request "${EROOT}"/usr/bin/HEAD
	fi
}
