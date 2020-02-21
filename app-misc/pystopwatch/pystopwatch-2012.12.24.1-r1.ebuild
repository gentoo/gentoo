# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

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
	$(python_gen_cond_dep '
		dev-python/pygtk:2[${PYTHON_MULTI_USEDEP}]
	')
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
