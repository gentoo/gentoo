# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils versionator gnome2-utils qmake-utils toolchain-funcs

DESCRIPTION="an Atari Jaguar emulator"
HOMEPAGE="http://www.icculus.org/virtualjaguar/"
SRC_URI="http://www.icculus.org/virtualjaguar/tarballs/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-libs/libcdio
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4[-egl]
	media-libs/libsdl[joystick,opengl,sound,video]
	sys-libs/zlib
	virtual/opengl"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.4"

S=${WORKDIR}/${PN}

pkg_pretend() {
	local ver=4.4

	if tc-is-gcc && ! version_is_at_least ${ver} $(gcc-version); then
		die "${PN} needs at least gcc ${ver} selected to compile."
	fi
}

src_prepare() {
	default
	sed -i \
		-e '/^Categories/s/$/;/' \
		virtualjaguar.desktop || die
}

src_configure() {
	eqmake4 virtualjaguar.pro -o makefile-qt
}

src_compile() {
	emake -j1 libs
	emake
}

src_install() {
	dobin ${PN}
	dodoc README docs/{TODO,WHATSNEW}
	doman docs/virtualjaguar.1
	domenu virtualjaguar.desktop
	newicon -s 128 res/vj-icon.png ${PN}.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "The ${PN} ROM path is no-longer hardcoded, "
	elog "set it from within, the ${PN} GUI."
	elog
	elog "The ROM extension supported by ${PN} is .j64, "
	elog ".jag files will be interpreted as Jaguar Server executables."
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
