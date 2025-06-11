# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DBOOK
DIST_VERSION=1.78
inherit perl-module

DESCRIPTION="A simple starter kit for any module"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Module-Runtime
	>=dev-perl/Pod-Parser-1.210.0
	>=dev-perl/Software-License-0.103.5
	>=virtual/perl-Test-Harness-0.210.0
	>=virtual/perl-Test-Simple-0.940.0
	>=virtual/perl-version-0.770.0
"

PERL_RM_FILES=( t/pod.t t/pod-coverage.t )
