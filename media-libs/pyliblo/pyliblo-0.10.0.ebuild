# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
inherit distutils-r1

DESCRIPTION="A Python wrapper for the liblo OSC library"
HOMEPAGE="http://das.nasophon.de/pyliblo"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=media-libs/liblo-0.27
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"
