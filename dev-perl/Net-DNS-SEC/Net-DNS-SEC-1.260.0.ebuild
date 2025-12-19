# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NLNETLABS
DIST_VERSION=1.26
inherit perl-module

DESCRIPTION="DNSSEC extensions to Net::DNS"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-libs/openssl:=
	>=virtual/perl-Carp-1.100.0
	>=virtual/perl-Exporter-5.630.0
	>=virtual/perl-File-Spec-3.290.0
	>=virtual/perl-MIME-Base64-3.70.0
	>=dev-perl/Net-DNS-1.80.0
"
DEPEND="dev-libs/openssl:="
# pkgconfig is used to find openssl
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.480.0
	virtual/pkgconfig
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
