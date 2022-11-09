# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/lagadic/vision_visp"
KEYWORDS="~amd64 ~arm"
VER_PREFIX="noetic-"
ROS_SUBDIR=${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs dev-ros/geometry_msgs"

inherit ros-catkin

DESCRIPTION="Wraps the ViSP moving edge tracker provided by the ViSP library"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/dynamic_reconfigure
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/image_proc
	dev-ros/image_transport
	dev-ros/nodelet
	dev-ros/resource_retriever
	dev-ros/roscpp
	dev-ros/sensor_msgs
	dev-ros/tf[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/numpy[\${PYTHON_USEDEP}]")
	sci-libs/ViSP:=[opencv,X]
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}"
if [ "${PV#9999}" = "${PV}" ] ; then
	S="${WORKDIR}/vision_visp-noetic-${PV}/${ROS_SUBDIR}"
fi

src_compile() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_compile
}
