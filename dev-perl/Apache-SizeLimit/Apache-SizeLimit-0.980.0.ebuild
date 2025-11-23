# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SHAY
DIST_VERSION=0.98
inherit perl-module

DESCRIPTION="Graceful exit for large children"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
LICENSE="Apache-2.0"

PERL_RM_FILES=(
	t/pod.t
)

# mod_perl < 2.0.5 bundles Apache-SizeLimit
RDEPEND="
	dev-perl/Linux-Pid
	!<www-apache/mod_perl-2.0.5
	>=www-apache/mod_perl-2.0.5
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-perl/Apache-Test-1.360.0
		!www-apache/mpm_itk
	)
"
