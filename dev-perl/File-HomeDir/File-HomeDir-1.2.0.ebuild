# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=REHSACK
DIST_VERSION=1.002
inherit perl-module

DESCRIPTION="Get home directory for self or other user"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="+xdg test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-File-Path-2.10.0
	>=virtual/perl-File-Spec-3
	>=virtual/perl-File-Temp-0.190.0
	>=dev-perl/File-Which-0.50.0
	xdg? ( x11-misc/xdg-user-dirs )"

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.900.0
	)
"
