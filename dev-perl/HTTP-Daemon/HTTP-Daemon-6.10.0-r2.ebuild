# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GAAS
DIST_VERSION=6.01
inherit perl-module

DESCRIPTION="Base class for simple HTTP servers"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	!<dev-perl/libwww-perl-6
	>=dev-perl/HTTP-Date-6.0.0
	virtual/perl-IO
	>=dev-perl/HTTP-Message-6.0.0
	>=dev-perl/LWP-MediaTypes-6.0.0
"
DEPEND="${RDEPEND}"
