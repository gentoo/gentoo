# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN=${PN/pyp/PyP}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A lightweight panel/taskbar for X11 window managers"
HOMEPAGE="http://pypanel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="x11-libs/libXft
	dev-python/python-xlib[${PYTHON_USEDEP}]
	media-libs/imlib2[X]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
