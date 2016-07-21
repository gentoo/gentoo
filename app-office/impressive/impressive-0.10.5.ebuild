# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

MY_PN="Impressive"

DESCRIPTION="Stylish way of giving presentations with Python"
HOMEPAGE="http://impressive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}/${PV}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${PYTHON_DEPS}
	!>=dev-python/pillow-3.0.0
	app-text/pdftk
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	x11-misc/xdg-utils
	x11-apps/xrandr
	app-text/ghostscript-gpl
	|| ( media-fonts/dejavu media-fonts/corefonts )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${MY_PN}-${PV}

src_install() {
	python_foreach_impl python_doscript ${PN}.py

	# compatibility symlinks
	dosym impressive.py /usr/bin/impressive
	dosym impressive.py /usr/bin/keyjnote

	# docs
	doman impressive.1
	dohtml impressive.html
	dodoc changelog.txt demo.pdf
}
