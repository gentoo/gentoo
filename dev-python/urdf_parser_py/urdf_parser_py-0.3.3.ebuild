# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5} )
inherit distutils-r1

DESCRIPTION="URDF parser for Python"
HOMEPAGE="http://wiki.ros.org/urdfdom_py"
SRC_URI="https://github.com/ros/urdf_parser_py/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
"
