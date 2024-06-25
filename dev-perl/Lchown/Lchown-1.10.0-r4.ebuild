# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NCLEATON
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Use the lchown(2) system call from Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ppc64 sparc x86"

BDEPEND="
	${RDEPEND}
	dev-perl/Module-Build
"

PERL_RM_FILES=(
	t/pod-coverage.t
	t/pod.t
)
