# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Build and operate a electronic whiteboard Wiimote and IR Pen"
HOMEPAGE="https://github.com/pnegre/python-whiteboard"
SRC_URI="https://dev.gentoo.org/~lxnay/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-misc/cwiid[python,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pybluez[${PYTHON_USEDEP}]
	dev-python/PyQt4[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-20101012-fix-desktop-qa.patch )

src_install() {
	default

	# install correctly in python sitedir
	python_domodule "${ED%/}"/usr/lib/python-whiteboard
	rm -r "${ED%/}"/usr/lib || die
}
