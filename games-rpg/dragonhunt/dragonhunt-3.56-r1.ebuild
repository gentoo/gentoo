# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/dragonhunt/dragonhunt-3.56-r1.ebuild,v 1.5 2015/01/26 09:50:13 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 games

MY_P="Dragon_Hunt-${PV}"
DESCRIPTION="A simple graphical RPG"
HOMEPAGE="http://emhsoft.com/dh.html"
SRC_URI="http://emhsoft.com/dh/${MY_P}.tar.gz"

LICENSE="GPL-2 CC-SA-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pygame[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# Where to look for modules to load.
	sed -i "s:\.\./modules/:${GAMES_DATADIR}/${PN}/:" \
		code/g.py \
		code/map_editor.py \
		code/rpg.py || die

	# Where to look for keybinding
	sed -i "s:\.\./settings:${GAMES_SYSCONFDIR}/${PN}/settings:" \
		code/g.py || die

	# Save games in ~/.${PN}/.
	sed -i \
		-e "s:^\(from os import.*\):\1\, environ:" \
		-e "s:g.mod_dir.*\"/saves/\?\":environ[\"HOME\"] + \"/.${PN}/\":" \
		code/g.py code/loadgame.py || die

	# Save maps in ~/.
	sed -i \
		-e "s:^\(from os import.*\):\1\, environ:" \
		-e "s:g.mod_dir.*\"map\.txt\":environ[\"HOME\"]\ +\ \"/dh_map.txt\":" \
		code/map_editor.py || die
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r modules/*

	insinto "${GAMES_SYSCONFDIR}"/${PN}
	doins settings.txt

	insinto "$(games_get_libdir)"/${PN}
	doins code/*.py

	games_make_wrapper ${PN} "${EPYTHON} ./rpg.py" "$(games_get_libdir)"/${PN}
	games_make_wrapper ${PN}-mapeditor "${EPYTHON} ./map_editor.py" \
		"$(games_get_libdir)"/${PN}

	newicon modules/default/images/buttons/icon.png ${PN}.png
	make_desktop_entry ${PN} "Dragon Hunt"
	make_desktop_entry ${PN}-mapeditor "Dragon Hunt - Editor"

	dodoc README.txt docs/{Changelog,Items.txt,example_map.txt,tiles.txt}
	dohtml docs/*.html

	python_optimize "${ED}$(games_get_libdir)"/${PN} \
		"${ED}${GAMES_DATADIR}/${PN}/Dark Ages/data/make_map.py"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	echo
	elog "If you use the map editor then note that maps will be saved as"
	elog "~/dh_map.txt and must be move to the correct module directory"
	elog "(within ${GAMES_DATADIR}/${PN}) by hand."
	echo
}
