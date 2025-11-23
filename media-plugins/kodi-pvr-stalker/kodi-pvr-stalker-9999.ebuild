# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kodi's Stalker client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.stalker"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.stalker.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/kodi-pvr/pvr.stalker/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.stalker-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/jsoncpp:=
	dev-libs/tinyxml
	=media-tv/kodi-${PV%%.*}*
"
RDEPEND="${DEPEND}"

src_prepare() {
	if [[ -d depends ]]; then
		rm -r depends || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
