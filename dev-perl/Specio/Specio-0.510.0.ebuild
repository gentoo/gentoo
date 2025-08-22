# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.51
inherit perl-module

DESCRIPTION="Type constraints and coercions for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 x86"
IUSE="minimal"

RDEPEND="
	|| ( dev-perl/Clone dev-perl/Clone-PP )
	dev-perl/Clone-Choose
	dev-perl/Devel-StackTrace
	dev-perl/Eval-Closure
	dev-perl/MRO-Compat
	dev-perl/Module-Implementation
	dev-perl/Module-Runtime
	>=dev-perl/Role-Tiny-1.3.3
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Sub-Quote
	dev-perl/Test-Fatal
	>=virtual/perl-Test-Simple-0.960.0
	dev-perl/Try-Tiny
	dev-perl/XString
	>=virtual/perl-version-0.830.0
	!minimal? ( >=dev-perl/Ref-Util-0.112.0 )
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Test-Needs
	)
"
