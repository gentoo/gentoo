# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual package for building against PoDoFo"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm hppa ppc ppc64 ~sparc x86"
IUSE="+boost idn debug test +tools"
RESTRICT="!test? ( test )"

# Pull in boost for build-against header dependency (see bug #503802).
RDEPEND="
	app-text/podofo:0/${PV}[boost=,idn=,debug=,test=,tools=]
	boost? ( dev-libs/boost )
"
