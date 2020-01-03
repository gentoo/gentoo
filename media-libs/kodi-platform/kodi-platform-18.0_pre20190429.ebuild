# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/xbmc/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	GIT_COMMIT="915da08"
	SRC_URI="https://github.com/xbmc/${PN}/tarball/${GIT_COMMIT} -> ${P}.tar.gz"
	S="${WORKDIR}/xbmc-kodi-platform-${GIT_COMMIT}"
fi

DESCRIPTION="Kodi platform support library"
HOMEPAGE="https://kodi.tv"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-18*
	=dev-libs/libplatform-2*
	dev-libs/tinyxml
	"

RDEPEND="${DEPEND}"
