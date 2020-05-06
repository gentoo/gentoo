# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TMTM
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Parse a CDDB/freedb data file"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86"

PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
