# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/qt_gui_core"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Helpers to work with dot graphs"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/pydot[${PYTHON_USEDEP}]
	>=dev-ros/python_qt_binding-0.3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pygraphviz[${PYTHON_USEDEP}]
	)"
