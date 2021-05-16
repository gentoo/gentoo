# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TJENNESS
DIST_VERSION=0.61
inherit perl-module

DESCRIPTION="Convert Pod data to formatted LaTeX"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	virtual/perl-Pod-Parser
	virtual/perl-if
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
"
