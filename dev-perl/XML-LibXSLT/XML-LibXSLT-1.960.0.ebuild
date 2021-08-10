# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=1.96
inherit perl-module

DESCRIPTION="A Perl module to parse XSL Transformational sheets using gnome's libXSLT"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	virtual/perl-Encode
	>=dev-perl/XML-LibXML-1.700.0
	>=dev-libs/libxslt-1.1.32
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
"
PERL_RM_FILES=(
	"t/cpan-changes.t" "t/pod.t"
	"t/style-trailing-space.t"
)
PATCHES=(
	"${FILESDIR}/${PN}-1.96-entityexpandtest.patch"
)
