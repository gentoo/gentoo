# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kodi-addon

DESCRIPTION="Kodi's IPTVSimple client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.iptvsimple"

case ${PV} in
9999)

	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.iptvsimple.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/kodi-pvr/pvr.iptvsimple/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.iptvsimple-${PV}-${CODENAME}"
	;;
esac

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	dev-libs/pugixml
	=media-tv/kodi-19*
	sys-libs/zlib
	"

RDEPEND="
	${DEPEND}
	"

src_prepare() {
	[ -d depends ] && rm -rf depends || die
	cmake_src_prepare
}
