# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/python_qt_binding"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Infrastructure for an integrated graphical user interface based on Qt"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
