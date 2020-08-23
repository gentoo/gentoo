# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/ros_comm"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=tools/${PN}

inherit ros-catkin user

DESCRIPTION="Tool for easily launching multiple ROS nodes"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/roslib[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/rospkg[\${PYTHON_USEDEP}]")
	dev-ros/rosclean[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep "dev-python/pyyaml[\${PYTHON_USEDEP}]")
	dev-ros/rosgraph_msgs[${CATKIN_MESSAGES_PYTHON_USEDEP}]
	dev-ros/rosparam[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosmaster[${PYTHON_SINGLE_USEDEP}]
	dev-ros/rosout
"
DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep "dev-util/rosdep[\${PYTHON_USEDEP}]")
		$(python_gen_cond_dep "dev-python/nose[\${PYTHON_USEDEP}]")
		dev-ros/test_rosmaster
	)"

src_test() {
	export ROS_PACKAGE_PATH="${S}:${S}/../rosmaster/:${EPREFIX}/usr/share/ros_packages/rosparam:${EPREFIX}/usr/share/ros_packages/roslib:${EPREFIX}/usr/share/ros_packages/rosout"
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
