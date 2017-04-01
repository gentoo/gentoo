# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=REHSACK
DIST_VERSION=0.418
inherit perl-module

DESCRIPTION="Compiled List::MoreUtils functions"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"
# See XS.pm/LICENSE
LICENSE="Apache-2.0 || ( Artistic GPL-1+ )"

RDEPEND="
	!<dev-perl/List-MoreUtils-0.417.1
	>=virtual/perl-XSLoader-0.220.0
"
DEPEND="${RDEPEND}
	virtual/perl-Carp
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-IPC-Cmd
	test? (
		>=dev-perl/List-MoreUtils-0.417.1
		>=virtual/perl-Test-Simple-0.960.0
	)
"
