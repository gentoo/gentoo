# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit gnome2-utils distutils-r1 games

DESCRIPTION="A 3D action game with multiplayer mode and amazing graphics"
HOMEPAGE="http://oomadness.tuxfamily.org/en/slune/"
SRC_URI="http://download.gna.org/slune/Slune-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/opengl
	>=media-libs/libsdl-1.2.6
	>=dev-python/soya-0.9
	>=dev-python/py2play-0.1.9
	>=dev-python/pyopenal-0.1.3
	>=dev-python/pyogg-1.1
	>=dev-python/pyvorbis-1.1"
DEPEND="${RDEPEND}"

S=${WORKDIR}/Slune-${PV}

python_install() {
	distutils-r1_python_install \
		--install-scripts="${GAMES_BINDIR}" \
		--install-data="${GAMES_DATADIR}" \
		--install-lib="$(python_get_sitedir)"

	# FHS broke the logic, fix it
	local i
	for i in $(ls -I locale "${ED}${GAMES_DATADIR}"/${PN}) ; do
		dosym "${GAMES_DATADIR}/${PN}/${i}" "$(python_get_sitedir)/${PN}/${i}"
	done
}

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install

	# fix install dest of locales
	mv "${ED}${GAMES_DATADIR}"/${PN}/locale "${ED}"/usr/share/locale || die

	newicon -s 48 images/${PN}.48.png ${PN}.png
	make_desktop_entry ${PN} "Slune"

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
