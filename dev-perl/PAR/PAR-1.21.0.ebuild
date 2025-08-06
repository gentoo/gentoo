# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSCHUPP
DIST_VERSION=1.021
inherit perl-module

DESCRIPTION="Perl Archive Toolkit"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/Archive-Zip-1.0.0
	>=dev-perl/PAR-Dist-0.320.0
"

PERL_RM_FILES=( t/00-pod.t )
