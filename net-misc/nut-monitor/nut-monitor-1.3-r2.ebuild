# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="A graphical application to monitor and manage UPSes connected to a NUT server"
HOMEPAGE="http://www.lestat.st/informatique/projets/nut-monitor-en/"
SRC_URI="http://www.lestat.st/_media/informatique/projets/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_fr"

RDEPEND="dev-python/pygtk
	dev-python/pynut"
DEPEND=""

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-paths.patch
	epatch "${FILESDIR}"/${P}-paths2.patch
	python_convert_shebangs -r 2 .
}

src_install() {
	dobin NUT-Monitor
	dosym NUT-Monitor /usr/bin/${PN}

	insinto /usr/share/nut-monitor
	doins gui-${PV}.glade

	dodir /usr/share/nut-monitor/pixmaps
	insinto /usr/share/nut-monitor/pixmaps
	doins pixmaps/*

	doicon ${PN}.png
	domenu ${PN}.desktop

	dodoc README

	if use linguas_fr; then
		insinto /usr/share/locale/fr/LC_MESSAGES/
		doins locale/fr/LC_MESSAGES/NUT-Monitor.mo
	fi
}
