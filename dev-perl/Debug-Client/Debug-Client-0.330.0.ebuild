# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SZABGAB
DIST_VERSION=0.33
inherit perl-module

DESCRIPTION="Client side code for perl debugger"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/PadWalker-1.980.0
	>=dev-perl/Term-ReadLine-Gnu-1.200.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-perl/File-HomeDir-1.0.0
		>=dev-perl/Test-CheckDeps-0.10.0
		>=dev-perl/Test-Class-0.420.0
		>=dev-perl/Test-Deep-0.112.0
		>=dev-perl/Test-Requires-0.70.0
		>=dev-perl/PadWalker-1.920.0
		>=dev-perl/Term-ReadLine-Perl-1.30.300
	)
"

PERL_RM_FILES=(
	t/03-pod.t
	t/04-pod-coverage.t
)
