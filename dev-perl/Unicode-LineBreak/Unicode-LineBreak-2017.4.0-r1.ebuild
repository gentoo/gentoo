# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEZUMI
DIST_VERSION=2017.004

inherit perl-module

DESCRIPTION="UAX #14 Unicode Line Breaking Algorithm"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-perl/MIME-Charset
	virtual/perl-Encode"
DEPEND="${RDEPEND}"
PATCHES=("${FILESDIR}/${PN}-2017.004-dotinc.patch")
PERL_RM_FILES=("t/pod.t")
