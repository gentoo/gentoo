# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.013
inherit perl-module

DESCRIPTION="Argument type classification"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~s390 ~sh ~sparc ~x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"

PATCHES=( "${FILESDIR}/${P}-op_sibling.patch"
	  "${FILESDIR}/${P}-no-dot-inc.patch" )

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.10.0
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	>=virtual/perl-ExtUtils-CBuilder-0.150.0
	test? (
		virtual/perl-Test-Simple
	)
"
