# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TMUELLER
DIST_VERSION=0.04007
inherit perl-module

DESCRIPTION="throw HTTP-Errors as (Exception::Class-) Exceptions"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/Exception-Class-1.290.0
	>=dev-perl/HTTP-Message-5.817.0
	>=virtual/perl-Scalar-List-Utils-1.220.0
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Exception-0.290.0
		>=dev-perl/Test-NoWarnings-1.40.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"

PERL_RM_FILES=(
	t/eol.t
	t/manifest.t
	t/pod.t
	t/eol_special.t
	t/boilerplate.t
)
