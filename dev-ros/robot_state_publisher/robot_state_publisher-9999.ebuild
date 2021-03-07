# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros/robot_state_publisher"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Package for publishing the state of a robot to tf"
LICENSE="BSD"
SLOT="0"
IUSE=""
DATA="joint_states_indexed.bag"
for i in ${DATA}; do
	SRC_URI="${SRC_URI}
		http://wiki.ros.org/robot_state_publisher/data?action=AttachFile&do=get&target=${i} -> ${P}-${i}"
done

RDEPEND="
	dev-ros/kdl_parser
	dev-cpp/eigen:3
	sci-libs/orocos_kdl:=
	dev-ros/roscpp
	dev-ros/rosconsole
	dev-ros/rostime
	dev-ros/tf2_ros
	dev-ros/tf2_kdl
	dev-ros/kdl_conversions
	dev-ros/sensor_msgs
	dev-ros/tf
	dev-ros/urdf
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-ros/rosbag[${PYTHON_SINGLE_USEDEP}]
	)
"

src_prepare() {
	ros-catkin_src_prepare
	for i in ${DATA}; do
		cp "${DISTDIR}/${P}-${i}" "${S}/${i}" || die
	done
	sed -e "s#http://wiki.ros.org/robot_state_publisher/data?action=AttachFile&do=get&target=#file://${S}#" -i CMakeLists.txt || die
}

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
