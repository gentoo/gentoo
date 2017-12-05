# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=BINGOS
DIST_VERSION=7.24
inherit eutils perl-module

DESCRIPTION="Create a module Makefile"
HOMEPAGE="http://makemaker.org ${HOMEPAGE}"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

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
