# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=2012
inherit perl-module

DESCRIPTION="Canary to check perl compatibility for schmorp's modules"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	perl-module_src_test
	perl -Mblib="${S}" -M"Canary::Stability ${DIST_VERSION} ()" -e1	||
		die "Could not load Canary::Stability"
}
