# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin user

DESCRIPTION="Tool for easily launching multiple ROS nodes"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roslib[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-ros/rosclean[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosparam[${PYTHON_USEDEP}]
	dev-ros/rosmaster[${PYTHON_USEDEP}]
	dev-ros/rosout
"
DEPEND="${RDEPEND}
	test? (
		dev-util/rosdep[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-ros/test_rosmaster
	)"
PATCHES=( "${FILESDIR}/timeout.patch" )

src_test() {
	rosdep update
	ros-catkin_src_test
}

src_install() {
	ros-catkin_src_install

	dodir /etc/ros
	sed -e "s/@PKG_VERSION@/${PV}/" "${FILESDIR}/roscore.xml.in" > "${ED}/etc/ros/roscore.xml" || die

	newinitd "${FILESDIR}/roscore.initd" roscore
	newconfd "${FILESDIR}/roscore.confd" roscore

	newinitd "${FILESDIR}/roslaunch.initd" roslaunch
	newconfd "${FILESDIR}/roslaunch.confd" roslaunch

	doenvd "${FILESDIR}/40roslaunch"

	# Needed by test_roslaunch
	insinto /usr/share/${PN}
	doins test/xml/noop.launch
}

pkg_preinst() {
	enewgroup ros
	enewuser ros -1 -1 /home/ros ros
}
