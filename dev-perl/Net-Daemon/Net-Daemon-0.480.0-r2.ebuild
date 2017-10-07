# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MNOONING
DIST_VERSION=0.48
inherit perl-module

DESCRIPTION="Abstract base class for portable servers"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""
PATCHES=(
	"${FILESDIR}/${P}-perl526.patch"
)
# loop-t and loop-child-t race-condition
# due to Net::Daemon::Test writing
# specific files to CWD
DIST_TEST="do"
