# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 cmake-utils

EGIT_REPO_URI="https://github.com/xbmc/kodi-platform"
EGIT_BRANCH="Jarvis"

DESCRIPTION="Kodi platform support library"
HOMEPAGE="https://github.com/xbmc/kodi-platform"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

# libplatform changed in version 2 from platform to p8-platform which makes it incompatible
DEPEND="=dev-libs/libplatform-1*
	dev-libs/tinyxml
	=media-tv/kodi-16*"
RDEPEND="${DEPEND}"
