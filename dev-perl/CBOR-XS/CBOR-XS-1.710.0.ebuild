# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=1.71
inherit perl-module

DESCRIPTION="Concise Binary Object Representation (CBOR, RFC7049)"
# License note: see bottom of ecb.h license block
LICENSE="GPL-3 || ( GPL-2+ BSD )"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Types-Serialiser
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	dev-perl/Canary-Stability
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"
