# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/opencv_apps"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="OpenCV applications for ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/image_transport
	dev-ros/nodelet
	dev-libs/console_bridge:=
	dev-ros/roscpp
	>=media-libs/opencv-3.3:0=[contrib]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/roslaunch
		dev-ros/rostest
		dev-ros/rosbag
		dev-ros/rosservice
		dev-ros/rostopic
		dev-ros/image_proc
		dev-ros/topic_tools
		dev-ros/compressed_image_transport
	)
"
