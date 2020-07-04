# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/vision_opencv"
KEYWORDS="~amd64 ~arm"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Converts between ROS Image messages and OpenCV images"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosconsole
	>=media-libs/opencv-3:=[contrib(+)]
	dev-libs/boost:=[threads,python,${PYTHON_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP},${CATKIN_MESSAGES_PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/boostpython.patch" "${FILESDIR}/ocv4.patch" )
