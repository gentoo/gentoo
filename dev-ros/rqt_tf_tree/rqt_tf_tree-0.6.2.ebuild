# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_tf_tree"

inherit ros-catkin

DESCRIPTION="GUI plugin for visualizing the ROS TF frame tree"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/qt_dotgraph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_graph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rqt_gui_py[${PYTHON_SINGLE_USEDEP}]
	dev-ros/tf2
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf2_ros[${PYTHON_SINGLE_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( $(python_gen_cond_dep "dev-python/mock[\${PYTHON_USEDEP}]") )"
PATCHES=( "${FILESDIR}/yaml.patch" )
