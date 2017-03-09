# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="A portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://0ldsk00l.ca/nestopia/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rdanbrook/nestopia.git"
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/rdanbrook/${PN}/archive/d7fae2aff1a93eac997d2b480652a1d068a2b6cf.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc gui"

RDEPEND="
	app-arch/libarchive:=
	media-libs/libao
	media-libs/libepoxy
	media-libs/libsdl2[sound,joystick,video]
	sys-libs/zlib
	gui? ( x11-libs/gtk+:3 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DENABLE_GTK=$(usex gui)
		-DENABLE_DOC=$(usex doc)
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
