# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHROMATIC
DIST_VERSION=1.20140328
inherit perl-module

DESCRIPTION="Hack around people calling UNIVERSAL::can() as a function"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	test? ( >=virtual/perl-Test-Simple-0.600.0 )
"
