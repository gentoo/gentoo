# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Zattoo PVR addon for Kodi"
HOMEPAGE="https://github.com/rbuehlma/pvr.zattoo"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/rbuehlma/pvr.zattoo.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/rbuehlma/pvr.zattoo/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.zattoo-${PV}-${CODENAME}"
	KEYWORDS="~amd64"
	;;
esac

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

DEPEND="
	dev-libs/rapidjson
	dev-libs/tinyxml2:=
	=media-tv/kodi-${PV%%.*}*
	virtual/opengl
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
