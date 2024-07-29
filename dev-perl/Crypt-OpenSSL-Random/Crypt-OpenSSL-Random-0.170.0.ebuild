# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RURBAN
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="OpenSSL pseudo-random number generator access"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-libs/openssl:=
"
DEPEND="
	dev-libs/openssl:=
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Crypt-OpenSSL-Guess-0.110.0
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=(
	t/z_kwalitee.t
	t/z_manifest.t
	t/z_meta.t
	t/z_perl_minimum_version.t
	t/z_pod-coverage.t
	t/z_pod.t
)

mydoc="ToDo"

export OPENSSL_PREFIX="${ESYSROOT}/usr"
