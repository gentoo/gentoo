# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-planning/navigation"
ROS_SUBDIR=${PN}
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="Probabilistic localization system for a robot moving in 2D"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

TEST_DATA="
basic_localization_stage_indexed.bag
global_localization_stage_indexed.bag
small_loop_prf_indexed.bag
small_loop_crazy_driving_prg_indexed.bag
texas_greenroom_loop_indexed.bag
texas_willow_hallway_loop_indexed.bag
rosie_localization_stage.bag
willow-full.pgm
willow-full-0.05.pgm
"

for i in ${TEST_DATA}; do
	SRC_URI="${SRC_URI}
		http://download.ros.org/data/amcl/${i} -> ${P}-${i}"
done

RDEPEND="
	dev-ros/diagnostic_updater[${PYTHON_SINGLE_USEDEP}]
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/message_filters
	dev-ros/rosbag
		dev-libs/boost:=
	dev-ros/roscpp
	dev-ros/tf2
	dev-ros/tf2_ros
"
DEPEND="${RDEPEND}
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/nav_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/std_srvs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/tf2_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep "dev-python/python_orocos_kdl[\${PYTHON_USEDEP}]")
		dev-ros/map_server[${PYTHON_SINGLE_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/cmake.patch" )

src_prepare() {
	ros-catkin_src_prepare
	for i in ${TEST_DATA}; do
		cp "${DISTDIR}/${P}-${i}" "${S}/${i}" || die
	done
	sed -e "s#http://download.ros.org/data/amcl#file://${S}#" -i CMakeLists.txt || die
}

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
