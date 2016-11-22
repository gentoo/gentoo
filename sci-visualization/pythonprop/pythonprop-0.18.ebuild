# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Scripts to prepare and plot VOACAP propagation predictions"
HOMEPAGE="http://www.qsl.net/hz1jw/pythonprop"
SRC_URI="http://www.qsl.net/h/hz1jw/${PN}/downloads/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/basemap[${PYTHON_USEDEP}]
	sci-electronics/voacapl
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	app-text/rarian
"

src_prepare() {
	# do not call update_destop_database here
	sed -ie "s/UPDATE_DESKTOP = /UPDATE_DESKTOP = # /g" data/Makefile.in || die
	# fix Desktop Entry
	sed -ie "s/HamRadio/HamRadio;/g" data/voacapgui.desktop.in || die
}
