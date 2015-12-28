# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=BINGOS
MODULE_VERSION=7.04
inherit eutils perl-module

DESCRIPTION="Create a module Makefile"
HOMEPAGE="http://makemaker.org ${HOMEPAGE}"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="
	>=virtual/perl-ExtUtils-Command-1.160.0
	>=virtual/perl-ExtUtils-Install-1.520.0
	>=virtual/perl-ExtUtils-Manifest-1.700.0
	>=virtual/perl-File-Spec-0.800.0
"
RDEPEND="${DEPEND}"
PDEPEND="
	>=virtual/perl-CPAN-Meta-2.143.240
	>=virtual/perl-Parse-CPAN-Meta-1.441.400
	virtual/perl-Test-Harness
"

PATCHES=(
	"${FILESDIR}/7.04-delete_packlist_podlocal.patch"
	"${FILESDIR}/6.58-RUNPATH.patch"
)
SRC_TEST=do

src_prepare() {
	edos2unix "${S}/lib/ExtUtils/MM_Unix.pm"
	edos2unix "${S}/lib/ExtUtils/MM_Any.pm"

	export BUILDING_AS_PACKAGE=1
	perl-module_src_prepare
}
