# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="Kodi's Adaptive inputstream addon"
HOMEPAGE="https://github.com/peak3d/inputstream.adaptive.git"
KODI_PLUGIN_NAME="inputstream.adaptive"

case ${PV} in
9999)
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/peak3d/${KODI_PLUGIN_NAME}.git"
	EGIT_BRANCH="Matrix"
	inherit git-r3
	DEPEND="~media-tv/kodi-9999"
	;;
*)
	CODENAME="Leia"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/peak3d/${KODI_PLUGIN_NAME}/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${KODI_PLUGIN_NAME}-${PV}-${CODENAME}"
	DEPEND="=media-tv/kodi-18*:="
	;;
esac

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND+="
	dev-libs/expat
	"

RDEPEND="${DEPEND}"

src_prepare() {
	if [ -d depends ]; then rm -rf depends || die; fi

	cmake_src_prepare
}
