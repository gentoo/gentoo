# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

GIT_COMMIT="15edaf7"
DESCRIPTION="Kodi platform support library"
HOMEPAGE="https://github.com/xbmc/kodi-platform"
SRC_URI="https://github.com/xbmc/kodi-platform/tarball/${GIT_COMMIT} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/libplatform
	dev-libs/tinyxml
	=media-tv/kodi-16*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/xbmc-kodi-platform-${GIT_COMMIT}"
