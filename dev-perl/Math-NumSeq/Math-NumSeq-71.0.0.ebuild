# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KRYDE
DIST_VERSION=71
inherit perl-module

DESCRIPTION="number sequences (for example from OEIS)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test examples"

RDEPEND="
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Math-Factor-XS-0.400.0
	dev-perl/Math-Libm
	>=dev-perl/Math-Prime-XS-0.260.0
	virtual/perl-Module-Load
	>=dev-perl/Module-Pluggable-4.700.0
	dev-perl/Module-Util
	>=dev-perl/constant-defer-1.0.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Data-Float
		virtual/perl-Test
	)
"

# Note: Examples need extra deps, but they're not critical LATER
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto	examples
		dodoc -r examples/other/*
	fi
}
