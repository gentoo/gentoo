# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Pyro screensaver for Kodi"
HOMEPAGE="https://github.com/xbmc/screensaver.pyro"

case ${PV} in
9999)
	EGIT_BRANCH="Matrix"
	EGIT_REPO_URI="https://github.com/xbmc/screensaver.pyro.git"
	inherit git-r3
	;;
*)
	CODENAME="Matrix"
	SRC_URI="https://github.com/xbmc/screensaver.pyro/archive/${PV}-${CODENAME}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/screensaver.pyro-${PV}-${CODENAME}"
	KEYWORDS="~amd64 ~x86"
	;;
esac

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="=media-tv/kodi-${PV%%.*}*"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}/usr/$(get_libdir)/kodi"
	)
	cmake_src_configure
}
