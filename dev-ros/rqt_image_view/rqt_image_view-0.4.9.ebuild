# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_image_view"
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="GUI plugin for displaying images using image_transport"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge[${PYTHON_USEDEP}]
	media-libs/opencv:=
	dev-ros/image_transport
	dev-ros/rqt_gui[${PYTHON_USEDEP}]
	>=dev-ros/rqt_gui_cpp-0.3
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"
