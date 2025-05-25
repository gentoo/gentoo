# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Kodi PVR addon VNSI"
HOMEPAGE="https://github.com/kodi-pvr/pvr.vdr.vnsi"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.vdr.vnsi.git"
	inherit git-r3
	;;
*)
	CODENAME="Omega"
	SRC_URI="https://github.com/kodi-pvr/pvr.vdr.vnsi/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.vdr.vnsi-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"

DEPEND="
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
