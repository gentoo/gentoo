# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-geographic-info/geographic_info"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Python and C++ interfaces for manipulating geodetic coordinates"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/angles
	dev-ros/geographic_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/tf
	dev-ros/unique_id
	dev-ros/uuid_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	$(python_gen_cond_dep "dev-python/pyproj[\${PYTHON_USEDEP}]")
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	dev-ros/geographic_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/geometry_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	dev-ros/sensor_msgs[${CATKIN_MESSAGES_CXX_USEDEP}]
	test? (
		dev-ros/rosunit[${PYTHON_SINGLE_USEDEP}]
		dev-cpp/gtest
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
	)"
PATCHES=( "${FILESDIR}/py3.patch" )
