# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils python-utils-r1 python-r1 distutils-r1

DESCRIPTION="Python version of the board game Rush Hour"
HOMEPAGE="http://freecode.com/projects/pytraffic"
SRC_URI="http://alpha.uhasselt.be/Research/Algebra/Members/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="media-libs/libsdl:0[sound]
	media-libs/sdl-mixer"
RDEPEND="${DEPEND}
	dev-python/pygtk"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# FHS compliance
	sed -i \
		-e 's#return os.path.join(exec_dir,path)#return os.path.join(os.getcwd(),path)#' \
		Misc.py || die

	sed \
		-e "s#@GAMES_DATADIR@#/usr/share/${PN}#" \
		"${FILESDIR}"/${PN} > "${T}"/${PN} || die
}

python_install() {
	# install modules manually, build system broken
	python_moduleinto ${PN}
	python_domodule "${BUILD_DIR}"/lib/.

	# allow to import the stuff as module
	touch "${D}$(python_get_sitedir)"/${PN}/__init__.py || die

	# install python wrapper script to handle multiple ABI properly
	python_scriptinto /usr/bin
	python_doscript "${T}"/${PN}
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr/share/${PN}
	doins -r doc config.db extra_themes icons libglade music sound_test themes ttraffic.levels

	doicon -s 64 icons/64x64/${PN}.png
	make_desktop_entry ${PN} PyTraffic
}

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
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
