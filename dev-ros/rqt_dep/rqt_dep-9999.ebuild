# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_dep"

inherit ros-catkin

DESCRIPTION="GUI plugin for visualizing the ROS dependency graph"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/qt_dotgraph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/qt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/qt_gui_py_common[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_graph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		$(python_gen_cond_dep "dev-python/mock[\${PYTHON_USEDEP}]")
	)"
