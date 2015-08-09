# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

SRC_URI="https://github.com/ultrabug/py3status/archive/${PV}.tar.gz -> ${P}.tar.gz"

inherit distutils-r1

MY_PN="py3status"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="py3status is an extensible i3status wrapper written in python"
HOMEPAGE="https://github.com/ultrabug/py3status"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-misc/i3status"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}
