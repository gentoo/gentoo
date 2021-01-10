# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OALDERS
DIST_VERSION=2.0.1
inherit perl-module

DESCRIPTION="OATH One Time Passwords"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Digest-HMAC
	virtual/perl-Math-BigInt
	>=dev-perl/Moo-2.2.4
	dev-perl/Type-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Digest-SHA
		dev-perl/Test-Needs
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/author-pod-coverage.t
	t/author-pod-spell.t
	t/author-synopsis.t
	t/author-tidyall.t
	t/manifest.t
	t/pod-coverage.t
	t/pod.t
	t/release-cpan-changes.t
)
