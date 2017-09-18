# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MLEHMANN
DIST_VERSION=7.14
inherit perl-module eutils

DESCRIPTION="Provides a uniform interface to various event loops"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.520.0
	dev-perl/Canary-Stability
"
pkg_postinst() {
	optfeature "improved event-loop performance" 		'>=dev-perl/EV-4.0.0'
	optfeature "improved performance of Guard objects"	'>=dev-perl/Guard-1.20.0'
	optfeature "JSON relays over AnyEvent::Handle" 		'>=dev-perl/JSON-2.90.0' '>=dev-perl/JSON-XS-2.200.0'
	optfeature "SSL support for AnyEvent::Handle" 		'>=dev-perl/Net-SSLeay-1.330.0'
	# AnyEvent::AIO
	# Async::Interrupts
}
