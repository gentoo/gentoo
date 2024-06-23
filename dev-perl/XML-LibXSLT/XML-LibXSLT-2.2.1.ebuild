# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHLOMIF
DIST_VERSION=2.002001
inherit perl-module

DESCRIPTION="A Perl module to parse XSL Transformational sheets using GNOME's libxslt"

# https://github.com/shlomif/perl-XML-LibXSLT/issues/5
LICENSE="|| ( Artistic GPL-1+ ) MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/perl-Encode
	>=dev-perl/XML-LibXML-1.700.0
	>=dev-libs/libxslt-1.1.32
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-File-Path-2.60.0
	virtual/pkgconfig
"

PERL_RM_FILES=(
	"t/cpan-changes.t" "t/pod.t"
	"t/style-trailing-space.t"
)
