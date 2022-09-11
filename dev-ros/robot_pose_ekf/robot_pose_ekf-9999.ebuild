# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-planning/robot_pose_ekf"
KEYWORDS="~amd64 ~arm"
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/std_msgs"

inherit ros-catkin

DESCRIPTION="Estimate the 3D pose of a robot from pose measurements from various sources"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roscpp
	dev-ros/tf
	sci-libs/orocos-bfl
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
	)
	virtual/pkgconfig"

TEST_DATA="ekf_test2_indexed.bag zero_covariance_indexed.bag"

SRC_URI="${SRC_URI} test? ( "
for i in ${TEST_DATA}; do
	SRC_URI="${SRC_URI} http://download.ros.org/data/robot_pose_ekf/${i} -> ${P}-${i}"
done
SRC_URI="${SRC_URI} )"

src_prepare() {
	ros-catkin_src_prepare
	if use test; then
		for i in ${TEST_DATA} ; do
			cp "${DISTDIR}/${P}-${i}" "${S}/${i}" || die
		done
		sed \
			-e "s#http://download.ros.org/data/robot_pose_ekf#file://${S}#" \
			-i CMakeLists.txt || die
	fi
}

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
