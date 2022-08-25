# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_8,3_9,3_10} )
DISTUTILS_USE_SETUPTOOLS=rdepend

SRC_URI="https://github.com/ultrabug/py3status/archive/${PV}.tar.gz -> ${P}.tar.gz"

inherit distutils-r1

MY_PN="py3status"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="py3status is an extensible i3status wrapper written in python"
HOMEPAGE="https://github.com/ultrabug/py3status"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gevent minimal +udev"
# It feels useless to run tests on this simple package
# since upstream (I) runs tox on CI
RESTRICT="test"

RDEPEND="
	!minimal? ( x11-misc/i3status )
	gevent? ( >=dev-python/gevent-1.2.0[${PYTHON_USEDEP}] )
	udev? ( >=dev-python/pyudev-0.21.0[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S=${WORKDIR}/${MY_P}
