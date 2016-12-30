# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils toolchain-funcs

MY_P=${P/ue/}
DESCRIPTION="A portable Nintendo Entertainment System emulator written in C++"
HOMEPAGE="http://0ldsk00l.ca/nestopia/"
SRC_URI="mirror://sourceforge/nestopiaue/${PV%.*}/${MY_P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="
	app-arch/libarchive:=
	media-libs/libao
	media-libs/libsdl2[sound,joystick,video]
	sys-libs/zlib
	virtual/opengl
	virtual/glu
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS changelog.txt README.md README.unix )
HTML_DOCS=( readme.html )
PATCHES=(
	"${FILESDIR}"/${PN}-1.47-fix-buildsystem.patch
	"${FILESDIR}"/${PN}-1.47-fix-c++14.patch
)

src_configure() {
	tc-export CXX
	use doc && HTML_DOCS+=( doc/. )
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
