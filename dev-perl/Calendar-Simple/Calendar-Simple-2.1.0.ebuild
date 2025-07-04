# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAVECROSS
DIST_VERSION=v2.1.0
inherit perl-module

DESCRIPTION="Perl extension to create simple calendars"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~riscv ~x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/DateTime
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"

PERL_RM_FILES=( "t/pod_coverage.t" "t/pod.t" )
