# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SCHWIGON
DIST_VERSION=2.09.01
DIST_EXAMPLES=("eg/*")
inherit perl-module
S="${WORKDIR}/${PN}-2.09"

DESCRIPTION="Perl client Interface to SSH"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal test"

RDEPEND="
	>=dev-perl/Crypt-Curve25519-0.50.0
	dev-perl/Crypt-IDEA
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
PERL_RM_FILES=( # Gentoo integrity checks are used instead
	'SIGNATURE'
	't/00-signature.t'
)
src_prepare() {
	sed -i -r -e '/signature_target/d' \
		"${S}/Makefile.PL" || "Can't strip signing controls from Makefile.PL"
	perl-module_src_prepare
}
