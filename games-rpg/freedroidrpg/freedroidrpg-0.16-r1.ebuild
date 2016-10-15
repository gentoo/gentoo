# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit autotools eutils gnome2-utils python-any-r1

DESCRIPTION="A modification of the classical Freedroid engine into an RPG"
HOMEPAGE="http://freedroid.sourceforge.net/"
SRC_URI="ftp://ftp.osuosl.org/pub/freedroid/freedroidRPG-${PV}//freedroidRPG-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls opengl sound"

RDEPEND="
	virtual/jpeg:0
	media-libs/libpng:0
	media-libs/libsdl[opengl?,sound?,video]
	>=media-libs/sdl-gfx-2.0.21
	media-libs/sdl-image[jpeg,png]
	nls? ( virtual/libintl )
	opengl? ( virtual/opengl )
	sound? (
		media-libs/libogg
		media-libs/libvorbis
		media-libs/sdl-mixer[vorbis] )
	x11-libs/libX11"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	sed -i \
		-e '/^dist_doc_DATA/d' \
		-e '/-pipe/d' \
		-e '/^SUBDIRS/s/pkgs//' \
		Makefile.am || die
	python_fix_shebang src sound
	eautoreconf
}

src_configure() {
	econf \
		--disable-fastmath \
		--with-embedded-lua \
		--localedir=/usr/share/locale \
		$(use_enable nls) \
		$(use_enable opengl) \
		$(use_enable sound)
}

src_install() {
	local i

	default
	for i in 48 64 96 128
	do
		doicon -s ${i} pkgs/freedesktop/icons/hicolor/${i}x${i}/apps/freedroidRPG.png
	done
	doicon -s scalable pkgs/freedesktop/icons/hicolor/scalable/apps/freedroidRPG.svg
	make_desktop_entry freedroidRPG "Freedroid RPG" freedroidRPG
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	echo
	ewarn "${P} is not compatible with old save games."
	ewarn "Please start a new character."
	echo
}

pkg_postrm() {
	gnome2_icon_cache_update
}
