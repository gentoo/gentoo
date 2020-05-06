# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TMTM
DIST_VERSION=1.3
inherit perl-module

DESCRIPTION="Object-oriented wrapper around vec()"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
