# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=6.514
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="The only real threads in perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ev event"

RDEPEND="
	>=dev-perl/AnyEvent-5
	ev? ( >=dev-perl/EV-4.0.0 )
	event? ( >=dev-perl/Event-0.890.0 )
	>=dev-perl/Guard-0.500.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Storable-2.150.0
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	dev-perl/Canary-Stability
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
"
PATCHES=(
	"${FILESDIR}/${PV}-ev-config.patch"
)
src_configure() {
	local myopts=()
	use ev && myopts+=("EV")
	use event && myopts+=( "Event" )
	GENTOO_OPTS="${myopts[@]}" perl-module_src_configure
}
