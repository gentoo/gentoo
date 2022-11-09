# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Single image rectification and color processing"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/image_geometry
	dev-ros/image_transport
	dev-ros/nodelet
	dev-ros/nodelet_topic_tools
	dev-ros/roscpp
	dev-libs/console_bridge:=
	media-libs/opencv:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest
		dev-cpp/gtest
		dev-ros/camera_calibration_parsers
	)
"
PATCHES=( "${FILESDIR}/ocv_leak.patch" )
