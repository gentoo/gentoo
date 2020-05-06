# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=BIGPRESH
DIST_VERSION=1.12
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A class for european VAT numbers validation"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/HTTP-Message-1.0.0
	>=dev-perl/libwww-perl-1.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
