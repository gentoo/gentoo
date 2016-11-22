# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1

MY_P="Dragon_Hunt-${PV}"
DESCRIPTION="A simple graphical RPG"
HOMEPAGE="http://emhsoft.com/dh.html"
SRC_URI="http://emhsoft.com/dh/${MY_P}.tar.gz"

LICENSE="GPL-2 CC-SA-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/pygame[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Where to look for modules to load.
	sed -i "s:\.\./modules/:/usr/share/${PN}/:" \
		code/g.py \
		code/map_editor.py \
		code/rpg.py || die

	# Where to look for keybinding
	sed -i "s:\.\./settings:/etc/${PN}/settings:" \
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
	insinto /usr/share/${PN}
	doins -r modules/*

	insinto /etc/${PN}
	doins settings.txt

	insinto /usr/$(get_libdir)/${PN}
	doins code/*.py

	make_wrapper ${PN} "${EPYTHON} ./rpg.py" /usr/$(get_libdir)/${PN}
	make_wrapper ${PN}-mapeditor "${EPYTHON} ./map_editor.py" \
		/usr/$(get_libdir)/${PN}

	newicon modules/default/images/buttons/icon.png ${PN}.png
	make_desktop_entry ${PN} "Dragon Hunt"
	make_desktop_entry ${PN}-mapeditor "Dragon Hunt - Editor"

	dodoc README.txt docs/{Changelog,Items.txt,example_map.txt,tiles.txt}
	dodoc -r docs/*.html

	python_optimize "${ED}/usr/$(get_libdir)"/${PN} \
		"${ED}/usr/share/${PN}/Dark Ages/data/make_map.py"
}

pkg_postinst() {
	echo
	elog "If you use the map editor then note that maps will be saved as"
	elog "~/dh_map.txt and must be move to the correct module directory"
	elog "(within /usr/share/${PN}) by hand."
	echo
}
