# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_WARN_UNUSED_CLI=1
inherit eutils cmake-utils git-r3

DESCRIPTION="Development library for simulation games"
HOMEPAGE="http://www.simgear.org/"
EGIT_REPO_URI="git://git.code.sf.net/p/flightgear/${PN}
	git://mapserver.flightgear.org/${PN}"
EGIT_BRANCH="next"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="curl debug subversion test"

COMMON_DEPEND="
	dev-libs/expat
	>=dev-games/openscenegraph-3.2.0
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
	curl? ( net-misc/curl )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.44
"
RDEPEND="${COMMON_DEPEND}
	subversion? ( dev-vcs/subversion )
"

DOCS=(AUTHORS ChangeLog NEWS README Thanks)

src_configure() {
	local mycmakeargs=(
		-DENABLE_CURL=$(usex curl)
		-DENABLE_PKGUTIL=ON
		-DENABLE_RTI=OFF
		-DENABLE_SOUND=ON
		-DENABLE_TESTS=$(usex test)
		-DSIMGEAR_HEADLESS=OFF
		-DSIMGEAR_SHARED=ON
		-DSYSTEM_EXPAT=ON
	)
	cmake-utils_src_configure
}
