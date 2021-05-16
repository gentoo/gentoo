# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAVIDO
DIST_VERSION=0.29
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="extension to generate cryptographically-secure random bytes"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Crypt-Random-Seed
	virtual/perl-Exporter
	>=virtual/perl-MIME-Base64-3.30.0
	dev-perl/Math-Random-ISAAC
	>=virtual/perl-Scalar-List-Utils-1.210.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.560.0
	test? (
		virtual/perl-Data-Dumper
		>=virtual/perl-Test-Simple-0.980.0
		virtual/perl-Time-HiRes
		!minimal? (
			dev-perl/Statistics-Basic
		)
	)
"
PERL_RM_FILES=(
	t/00-boilerplate.t
	t/01-manifest.t
	t/02-pod.t
	t/03-pod-coverage.t
	t/04-perlcritic.t
	t/05-kwalitee.t
	t/06-meta-yaml.t
	t/07-meta-json.t
	t/09-changes.t
)
