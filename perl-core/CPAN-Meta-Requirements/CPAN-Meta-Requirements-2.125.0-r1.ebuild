# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/CPAN-Meta-Requirements/CPAN-Meta-Requirements-2.125.0-r1.ebuild,v 1.1 2014/07/25 21:26:12 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=2.125
inherit perl-module

DESCRIPTION="A set of version requirements for a CPAN dist"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-version-0.77
	!<perl-core/CPAN-Meta-2.120.920
"
DEPEND="${RDEPEND}
"

SRC_TEST="do"
