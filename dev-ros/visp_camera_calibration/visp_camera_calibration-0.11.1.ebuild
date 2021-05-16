# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/lagadic/vision_visp"
KEYWORDS="~amd64 ~arm"
VER_PREFIX="kinetic-"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/sensor_msgs dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Calibration of cameras using a customizable pattern and ViSP library"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/camera_calibration_parsers
	dev-ros/roscpp
	dev-ros/visp_bridge
	sci-libs/ViSP:=[X]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
"
if [ "${PV#9999}" = "${PV}" ] ; then
	S="${WORKDIR}/vision_visp-kinetic-${PV}/${ROS_SUBDIR}"
fi
PATCHES=( "${FILESDIR}/gcc6.patch" )
