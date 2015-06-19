# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/obtheme/obtheme-2013.2.20.2.ebuild,v 1.5 2015/04/08 17:27:17 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="A gui theme editor for openbox"
HOMEPAGE="http://xyne.archlinux.ca/projects/obtheme/"
SRC_URI="http://xyne.archlinux.ca/projects/obtheme/src/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/fuse-python
	x11-libs/gtk+:2
"

src_install() {
	python_foreach_impl python_doscript ${PN}
	domenu ${PN}.desktop
	dodoc README CHANGELOG
}
