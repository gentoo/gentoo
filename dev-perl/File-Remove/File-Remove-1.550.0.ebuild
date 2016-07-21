# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.55
inherit perl-module

DESCRIPTION="Remove files and directories"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-File-Path
	>=virtual/perl-File-Spec-3.290.0
"
DEPEND="${RDEPEND}
	virtual/perl-File-Temp
	>=dev-perl/Module-Build-0.280.0
	test? ( virtual/perl-Test-Simple )
"
