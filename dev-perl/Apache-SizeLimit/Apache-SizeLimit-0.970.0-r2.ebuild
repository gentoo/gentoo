# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PHRED
DIST_VERSION=0.97
inherit perl-module

DESCRIPTION="Graceful exit for large children"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
LICENSE="Apache-2.0"
IUSE="test"
RESTRICT="!test? ( test )"

PERL_RM_FILES=(
	t/pod.t
)
# mod_perl < 2.0.5 bundles Apache-SizeLimit
RDEPEND="dev-perl/Linux-Pid
	!<www-apache/mod_perl-2.0.5
	>=www-apache/mod_perl-2.0.5"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Linux-Smaps
		>=dev-perl/Apache-Test-1.360.0
		!www-apache/mpm_itk
	)
"
