# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_common_plugins"

inherit ros-catkin

DESCRIPTION="ROS backend graphical tools suite that can be used on/off of robot runtime"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rqt_action
	dev-ros/rqt_bag
	dev-ros/rqt_bag_plugins
	dev-ros/rqt_console
	dev-ros/rqt_dep
	dev-ros/rqt_graph
	dev-ros/rqt_image_view
	dev-ros/rqt_launch
	dev-ros/rqt_logger_level
	dev-ros/rqt_msg
	dev-ros/rqt_plot
	dev-ros/rqt_publisher
	dev-ros/rqt_py_console
	dev-ros/rqt_reconfigure
	dev-ros/rqt_service_caller
	dev-ros/rqt_shell
	dev-ros/rqt_srv
	dev-ros/rqt_top
	dev-ros/rqt_topic
	dev-ros/rqt_web
"
DEPEND="${RDEPEND}"
