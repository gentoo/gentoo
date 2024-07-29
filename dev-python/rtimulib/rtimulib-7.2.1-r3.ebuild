# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

MY_PN="RTIMULib"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Binding for RTIMULib, a versatile IMU library"
HOMEPAGE="https://github.com/RPi-Distro/RTIMULib"
SRC_URI="https://github.com/RPi-Distro/${MY_PN}/archive/V${PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}/Linux/python"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"
