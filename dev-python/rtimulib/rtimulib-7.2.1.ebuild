# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

MY_P="RTIMULib-${PV}"

DESCRIPTION="Python Binding for RTIMULib, a versatile IMU library"
HOMEPAGE="https://github.com/RPi-Distro/RTIMULib"
SRC_URI="https://github.com/RPi-Distro/RTIMULib/archive/V${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}/Linux/python"
