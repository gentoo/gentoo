# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEZUMI
DIST_VERSION=1.012.2
inherit perl-module

DESCRIPTION="Charset Informations for MIME"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="l10n_ja l10n_zh"

# Put JISX0213 here one day
# And POD2
RDEPEND="
	>=virtual/perl-Encode-1.980.0
	l10n_ja? ( >=dev-perl/Encode-EUCJPASCII-0.20.0 )
	l10n_zh? ( >=dev-perl/Encode-HanExtra-0.200.0  )
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=("t/pod.t")

PATCHES=(
	"${FILESDIR}/1.012-makefilepl.patch"
)
