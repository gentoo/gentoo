# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop gnome2-utils

DESCRIPTION="Clone of Super Monkey Ball using SDL/OpenGL"
HOMEPAGE="https://neverball.org"
SRC_URI="https://neverball.org/${P}.tar.gz"

LICENSE="GPL-2+ IJG"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"
RESTRICT="test"

RDEPEND="
	media-libs/libsdl2[sound,joystick,opengl,video]
	media-libs/sdl2-ttf
	media-libs/libpng:0=
	virtual/jpeg:0
	media-libs/libvorbis
	virtual/opengl
	dev-games/physfs
	media-fonts/dejavu
	media-fonts/wqy-microhei
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

PATCHES=("${FILESDIR}"/${P}-gcc-10.patch)

src_prepare() {
	default
	sed -i \
		-e 's:mapc:neverball-mapc:g' \
		-e 's:MAPC:NEVERBALL-MAPC:g' \
		-e '1 s/ 1 / 6 /' \
		dist/mapc.1 || die
	sed -i \
		-e '/CFLAGS.*O2/s:-O2:$(E_CFLAGS):' \
		-e '/CXXFLAGS.*O2/s:-O2:$(E_CXXFLAGS):' \
		-e "/^MAPC_TARG/s/mapc/${PN}-mapc/" \
		Makefile || die
}

src_compile() {
	emake \
		ENABLE_NLS=$(use nls && echo 1 || echo 0) \
		E_CFLAGS="${CFLAGS}" \
		E_CXXFLAGS="${CXXFLAGS}" \
		LOCALEDIR=/usr/share/locale \
		DATADIR="/usr/share/${PN}"
}

src_install() {
	local font

	dobin ${PN}-mapc neverball neverputt
	insinto "/usr/share/${PN}"
	doins -r data/*
	for font in DejaVuSans-Bold.ttf wqy-microhei.ttc; do
		rm -f "${ED}/usr/share/${PN}"/ttf/${font}
		dosym /usr/share/fonts/*/${font} \
			"/usr/share/${PN}"/ttf/${font}
	done
	if [[ -d locale ]] ; then
		insinto /usr/share
		doins -r locale
	fi
	dodoc doc/{authors.txt,manual.txt,release-notes.md} README.md

	local res name
	for name in ball putt; do
		for res in 16 32 64 128 256; do
			newicon -s ${res} dist/never${name}_${res}.png never${name}.png
		done
	done

	doman dist/*.6
	newman dist/mapc.1 neverball-mapc.6
	make_desktop_entry neverball Neverball
	make_desktop_entry neverputt Neverputt neverputt
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postrm() {
	gnome2_icon_cache_update
}
