# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=test/${PN}
CATKIN_HAS_MESSAGES=yes
CATKIN_MESSAGES_TRANSITIVE_DEPS="dev-ros/rosgraph_msgs dev-ros/std_msgs"

TEST_DATA="constants_gen1.bag
constants_gen2.bag
converged_gen1.bag
converged_gen2.bag
converged_gen3.bag
converged_gen4.bag
convergent_gen1.bag
convergent_gen2.bag
migrated_addsub_gen1.bag
migrated_explicit_gen1.bag
migrated_explicit_gen2.bag
migrated_explicit_gen3.bag
migrated_explicit_gen4.bag
migrated_implicit_gen1.bag
migrated_implicit_gen2.bag
migrated_implicit_gen3.bag
migrated_implicit_gen4.bag
migrated_mixed_gen1.bag
migrated_mixed_gen2.bag
migrated_mixed_gen3.bag
migrated_mixed_gen4.bag
partially_migrated_gen1.bag
partially_migrated_gen2.bag
partially_migrated_gen3.bag
partially_migrated_gen4.bag
renamed_gen1.bag
renamed_gen2.bag
renamed_gen3.bag
renamed_gen4.bag
subunmigrated_gen1.bag
unmigrated_gen1.bag
"
ROSBAG_DATA="
test_indexed_1.2.bag
chatter_50hz.bag
test_future_version_2.1.bag
test_rosbag_latched_pub.bag
"

inherit ros-catkin

DESCRIPTION="Unit tests for rosbag"
LICENSE="BSD"
SLOT="0"
IUSE=""

for i in ${TEST_DATA}; do
	SRC_URI="${SRC_URI}
		http://download.ros.org/data/test_rosbag/${i} -> ${P}-${i}"
done
for i in ${ROSBAG_DATA}; do
	SRC_URI="${SRC_URI}
		http://download.ros.org/data/rosbag/${i} -> ${P}-${i}"
done

RDEPEND="
	dev-ros/message_generation
	dev-ros/rosbag[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosconsole
	dev-ros/roscpp
	dev-ros/rostopic[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosunit[${PYTHON_SINGLE_USEDEP}]
	dev-ros/topic_tools[${PYTHON_SINGLE_USEDEP}]
	dev-ros/xmlrpcpp
"
DEPEND="${RDEPEND}
	test? (
		dev-libs/boost
		app-arch/bzip2
		dev-ros/rosout
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
	)
"

src_prepare() {
	ros-catkin_src_prepare
	for i in ${TEST_DATA} ${ROSBAG_DATA}; do
		cp "${DISTDIR}/${P}-${i}" "${S}/${i}" || die
	done
	sed -e "s#http://download.ros.org/data/test_rosbag/#file://${S}/#g" \
		-i bag_migration_tests/CMakeLists.txt \
		-i CMakeLists.txt || die
	sed -e "s#http://download.ros.org/data/rosbag/#file://${S}/#g" \
		-i bag_migration_tests/CMakeLists.txt \
		-i CMakeLists.txt || die
}

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
