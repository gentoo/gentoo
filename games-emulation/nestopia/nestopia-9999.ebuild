# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://0ldsk00l.ca/nestopia/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/0ldsk00l/nestopia.git"
else
	SRC_URI="https://github.com/0ldsk00l/nestopia/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"

RDEPEND="
	app-arch/libarchive:=
	media-libs/libglvnd
	media-libs/libsdl2[joystick,sound]
	sys-libs/zlib:=
	x11-libs/fltk:1[opengl]"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/autoconf-archive
	virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable doc)
}
