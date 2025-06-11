# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kodi's Njoy N7 client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.njoy"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.njoy.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/kodi-pvr/pvr.njoy/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.njoy-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/tinyxml
	=media-tv/kodi-${PV%%.*}*
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
