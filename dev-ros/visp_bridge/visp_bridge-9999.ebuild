# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/lagadic/vision_visp"
KEYWORDS="~amd64 ~arm"
VER_PREFIX="kinetic-"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Converts between ROS structures and ViSP structures"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	sci-libs/ViSP:=[xml]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/camera_calibration_parsers
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"
if [ "${PV#9999}" = "${PV}" ] ; then
	S="${WORKDIR}/vision_visp-kinetic-${PV}/${ROS_SUBDIR}"
fi
PATCHES=( "${FILESDIR}/gcc6.patch" )
