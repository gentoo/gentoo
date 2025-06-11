# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="MythTV PVR for Kodi"
HOMEPAGE="https://github.com/janbar/pvr.mythtv"

case ${PV} in
9999)
	EGIT_REPO_URI="https://github.com/janbar/pvr.mythtv.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/janbar/pvr.mythtv/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.mythtv-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	=media-tv/kodi-${PV%%.*}*
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
