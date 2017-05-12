# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual package for building against PoDoFo"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="+boost idn debug test"

# Pull in boost for build-against header dependency (see bug #503802).
RDEPEND="
	app-text/podofo:0/${PVR}[boost=,idn=,debug=,test=]
	boost? ( dev-libs/boost )
"
