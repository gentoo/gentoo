# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_9,3_10,3_11} )
DISTUTILS_USE_PEP517=hatchling

SRC_URI="https://github.com/ultrabug/py3status/archive/${PV}.tar.gz -> ${P}.tar.gz"

inherit distutils-r1

MY_PN="py3status"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="py3status is an extensible i3status wrapper written in python"
HOMEPAGE="https://github.com/ultrabug/py3status"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal +dbus +udev"
# It feels useless to run tests on this simple package
# since upstream (I) runs tox on CI
RESTRICT="test"

RDEPEND="
	!minimal? ( x11-misc/i3status )
	dbus? ( >=dev-python/dbus-python-1.3.2[${PYTHON_USEDEP}] >=dev-python/pygobject-3.46.0[${PYTHON_USEDEP}] )
	udev? ( >=dev-python/pyudev-0.21.0[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
