# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=BINGOS
DIST_VERSION=7.24
inherit eutils perl-module

DESCRIPTION="Create a module Makefile"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-ExtUtils-Install-1.520.0
	>=virtual/perl-ExtUtils-Manifest-1.700.0
	>=virtual/perl-File-Spec-0.800.0
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-File-Temp-0.220.0
		>=virtual/perl-Scalar-List-Utils-1.130.0
	)
"
PDEPEND="
	>=virtual/perl-CPAN-Meta-2.143.240
	>=virtual/perl-Parse-CPAN-Meta-1.441.400
	virtual/perl-Test-Harness
"

PATCHES=(
	"${FILESDIR}/7.24-delete_podlocal.patch"
	"${FILESDIR}/7.24-RUNPATH.patch"
)

src_prepare() {
	edos2unix "${S}/lib/ExtUtils/MM_Unix.pm"
	edos2unix "${S}/lib/ExtUtils/MM_Any.pm"

	export BUILDING_AS_PACKAGE=1
	perl-module_src_prepare
}
