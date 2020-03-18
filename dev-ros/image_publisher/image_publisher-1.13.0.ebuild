# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_pipeline"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Publish an image stream from single image file or avi file."
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	>=media-libs/opencv-4:=
	dev-ros/dynamic_reconfigure
	dev-ros/camera_info_manager
	dev-ros/image_transport
	dev-ros/nodelet
	dev-libs/console_bridge:=
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/ocv4.patch" )
