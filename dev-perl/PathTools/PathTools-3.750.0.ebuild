# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="XSAWYERX"
DIST_VERSION="3.75"
inherit perl-module

DESCRIPTION="Tools for working with directory and file names"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_prepare() {
	# calls open() on nonexistent dir, #590084
	rm -f "t/cwd_enoent.t" || die
	default
}
