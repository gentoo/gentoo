# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/lagadic/vision_visp"
KEYWORDS="~amd64 ~arm"
VER_PREFIX="kinetic-"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Online automated pattern-based object tracker relying on visual servoing"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/message_filters
	dev-ros/resource_retriever
	dev-ros/roscpp
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/visp_bridge
	dev-ros/visp_tracker
	sci-libs/ViSP:=[dmtx,zbar]
	dev-libs/boost:=[threads]
"
DEPEND="${RDEPEND}"
if [ "${PV#9999}" = "${PV}" ] ; then
	S="${WORKDIR}/vision_visp-kinetic-${PV}/${ROS_SUBDIR}"
fi

PATCHES=( "${FILESDIR}/boost170.patch" )
