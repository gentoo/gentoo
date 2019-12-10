# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SCHWIGON
DIST_VERSION=2.14
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Perl client Interface to SSH"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Crypt-Curve25519-0.50.0
	dev-perl/Crypt-IDEA
	>=dev-perl/CryptX-0.32.0
	virtual/perl-Digest-MD5
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	virtual/perl-IO
	>=dev-perl/Math-GMP-1.40.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/String-CRC32-1.200.0
	!minimal? (
		dev-perl/Digest-BubbleBabble
		dev-perl/Crypt-RSA
		dev-perl/TermReadKey
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.610.0 )
"

PERL_RM_FILES=(
	# Gentoo integrity checks are used instead
	'SIGNATURE'
	't/00-signature.t'
	# Annoying author tests
	't/99-perlcritic.t'
	't/99-pod.t'
	't/99-spellcheck.t'
	't/99-yaml.t'
)
PATCHES=(
	"${FILESDIR}/${PN}-2.14-no-signatures.patch"
)
