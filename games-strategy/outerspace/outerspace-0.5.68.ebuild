# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/outerspace/outerspace-0.5.68.ebuild,v 1.4 2015/04/08 18:11:44 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils distutils-r1 games

MY_PN=${PN/outerspace/Outer Space}
DESCRIPTION="on-line strategy game taking place in the dangerous universe"
HOMEPAGE="http://www.ospace.net/"
SRC_URI="mirror://sourceforge/ospace/Client/${PV}/Outer%20Space-${PV}.tar.gz -> ${P}.tar.gz
	mirror://sourceforge/ospace/Client/${PV}/outerspace_${PV}-0ubuntu1_all.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-python/pygame-1.7"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	default
	unpack ./data.tar.gz
}

python_install() {
	distutils-r1_python_install \
		--install-scripts="${GAMES_BINDIR}" \
		--install-data="${GAMES_DATADIR}/${PN}" \
		--install-lib="$(python_get_sitedir)"

	# source tarball is missing files
	# get them from ubuntu.deb
	insinto "$(python_get_sitedir)"/ige/ospace/Rules
	doins "${WORKDIR}"/usr/share/games/outerspace/libsrvr/ige/ospace/Rules/{Tech,techs}.spf
}

src_prepare() {
	# fix setup script
	# rework python start script to avoid shell-wrapper script
	epatch "${FILESDIR}"/${P}-setup.patch

	sed -i\
		-e "s:@GENTOO_DATADIR@:${GAMES_DATADIR}/${PN}:" \
		osc.py || die "sed failed"

	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	newicon -s 48 res/icon48.png ${PN}.png
	make_desktop_entry "osc.py" "${MY_PN}"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	einfo
	einfo "start the game via 'osc.py'"
	einfo
}

pkg_postrm() {
	gnome2_icon_cache_update
}
