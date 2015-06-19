# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/podofo-build/podofo-build-0.9.2.ebuild,v 1.1 2014/10/16 20:46:40 zmedico Exp $

EAPI=5

DESCRIPTION="Virtual package for building against PoDoFo"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 ~sparc x86"
IUSE="+boost idn debug test"

# Pull in boost for build-against header dependency (see bug #503802).
RDEPEND="
	~app-text/podofo-0.9.2[boost=,idn=,debug=,test=]
	boost? ( dev-libs/boost )
"
DEPEND=""
