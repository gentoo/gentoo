# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
	${PYTHON_DEPS}
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
