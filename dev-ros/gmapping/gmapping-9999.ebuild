# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/slam_gmapping"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="ROS wrapper for OpenSlam's Gmapping"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-ros/roscpp
	dev-ros/tf
	dev-ros/openslam_gmapping
	dev-ros/rosbag_storage
	dev-ros/nodelet
"
DEPEND="${RDEPEND}
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest
		dev-cpp/gtest
	)
"
TEST_DATA="
	basic_localization_stage_indexed.bag
	hallway_slow_2011-03-04-21-41-33.bag
	basic_localization_stage_groundtruth.pgm
"
PERCEPTION_TEST_DATA="
	test_replay_crash.bag
	test_turtlebot.bag
	test_upside_down.bag
"
SRC_URI="${SRC_URI} test? ( "
for i in ${TEST_DATA}; do
	SRC_URI="${SRC_URI} http://download.ros.org/data/gmapping/${i} -> ${P}-${i}"
done
for i in ${PERCEPTION_TEST_DATA}; do
	SRC_URI="${SRC_URI} https://github.com/ros-perception/slam_gmapping_test_data/raw/master/${i} -> ${P}-${i}"
done
SRC_URI="${SRC_URI} )"

src_prepare() {
	ros-catkin_src_prepare
	if use test; then
		for i in ${TEST_DATA} ${PERCEPTION_TEST_DATA}; do
			cp "${DISTDIR}/${P}-${i}" "${S}/${i}" || die
		done
		sed \
			-e "s#http://download.ros.org/data/gmapping#file://${S}#" \
			-e "s#https://github.com/ros-perception/slam_gmapping_test_data/raw/master#file://${S}#" \
			-i CMakeLists.txt || die
	fi
}
