# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/calibration"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Runs an optimization to estimate the a robot's kinematic parameters"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep "dev-python/numpy[\${PYTHON_USEDEP}]")
	dev-ros/rosgraph[${PYTHON_SINGLE_USEDEP}]
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/rospy[${PYTHON_SINGLE_USEDEP}]
	dev-ros/calibration_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	$(python_gen_cond_dep "dev-python/matplotlib[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/python_orocos_kdl[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/scipy[\${PYTHON_USEDEP}]")
	$(python_gen_cond_dep "dev-python/urdf_parser_py[\${PYTHON_USEDEP}]")
"
DEPEND="${RDEPEND}
	test? (
		dev-ros/rostest[${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	)"
PATCHES=( "${FILESDIR}/py3.patch" )

src_prepare() {
	ros-catkin_src_prepare
	sed -e 's/yaml.load/yaml.safe_load/g' -i src/*/*.py -i test/*.py || die
	2to3 -w src/*/*.py src/*/*/*.py test/*.py || die
}

src_test() {
	export ROS_PACKAGE_PATH="${S}:${ROS_PACKAGE_PATH}"
	ros-catkin_src_test
}
