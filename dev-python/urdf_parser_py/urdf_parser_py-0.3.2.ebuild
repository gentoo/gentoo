# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
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
	dev-ros/rospy[${PYTHON_USEDEP}]
"
