# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tvheadend Live TV and Radio PVR client addon for Kodi"
HOMEPAGE="https://github.com/kodi-pvr/pvr.hts"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/kodi-pvr/pvr.hts.git"
	inherit git-r3
else
	CODENAME="Matrix"
	SRC_URI="https://github.com/kodi-pvr/pvr.hts/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/pvr.hts-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="=media-tv/kodi-${PV%%.*}*"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
