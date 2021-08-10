# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ADAMK
DIST_VERSION=1.17
inherit perl-module

DESCRIPTION="DSA Signatures and Key Generation"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc sparc x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Data-Buffer-0.10.0
	dev-perl/Digest-SHA1
	virtual/perl-File-Spec
	>=dev-perl/File-Which-0.50.0
	virtual/perl-MIME-Base64
	>=virtual/perl-Math-BigInt-1.780.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		dev-perl/Convert-PEM
		dev-perl/Math-BigInt-GMP
		>=virtual/perl-Test-Simple-0.420.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.17-no-dot-inc.patch"
)
