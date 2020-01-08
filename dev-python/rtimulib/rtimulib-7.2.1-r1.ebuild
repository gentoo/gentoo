# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="no"
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

MY_PN="RTIMULib"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Binding for RTIMULib, a versatile IMU library"
HOMEPAGE="https://github.com/RPi-Distro/RTIMULib"
SRC_URI="https://github.com/RPi-Distro/${MY_PN}/archive/V${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

S="${WORKDIR}/${MY_P}/Linux/python"
