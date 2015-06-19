# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pystopwatch/pystopwatch-2012.12.24.1-r1.ebuild,v 1.4 2015/02/25 15:56:04 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="clock and two countdown functions that can minimize to the tray"
HOMEPAGE="http://xyne.archlinux.ca/projects/pystopwatch"
SRC_URI="http://xyne.archlinux.ca/projects/${PN}/src/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	gnome-base/librsvg
	${PYTHON_DEPS}
"
DEPEND=""

src_prepare() {
	unpack ./man/${PN}.1.gz
}

src_install() {
	python_doscript ${PN}
	doman ${PN}.1
}
