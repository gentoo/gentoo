# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
DIST_VERSION=6.57
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="The only real threads in perl"

LICENSE="|| ( Artistic GPL-1+ ) LGPL-2.1+ || ( BSD-2 GPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ev event valgrind"

RDEPEND="
	>=dev-perl/AnyEvent-7
	ev? ( >=dev-perl/EV-4.0.0 )
	event? ( >=dev-perl/Event-1.80.0 )
	>=dev-perl/Guard-0.500.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Storable-2.150.0
	dev-perl/common-sense
"
DEPEND="
	valgrind? ( dev-debug/valgrind )
"
BDEPEND="
	${RDEPEND}
	dev-perl/Canary-Stability
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"

PATCHES=(
	"${FILESDIR}/6.514.0-ev-config.patch"
	"${FILESDIR}/6.570.0-FORTIFY_SOURCE.patch"
	"${FILESDIR}/6.570.0-c23.patch"
)

src_configure() {
	local myopts=()
	use ev && myopts+=("EV")
	use event && myopts+=( "Event" )

	export CORO_USE_VALGRIND=$(usex valgrind y n)

	GENTOO_OPTS="${myopts[@]}" perl-module_src_configure
}
