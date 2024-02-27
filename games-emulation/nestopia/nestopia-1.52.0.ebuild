# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic xdg

DESCRIPTION="Portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://0ldsk00l.ca/nestopia/"
SRC_URI="https://github.com/0ldsk00l/nestopia/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	app-arch/libarchive:=
	media-libs/libglvnd
	media-libs/libsdl2[joystick,sound]
	sys-libs/zlib:=
	x11-libs/fltk:1[opengl]"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/autoconf-archive
	virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# silence the narrowing warnings on clang (#830469)
	append-cxxflags -Wno-narrowing

	econf $(use_enable doc)
}
