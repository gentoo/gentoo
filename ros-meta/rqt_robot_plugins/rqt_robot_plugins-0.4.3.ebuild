# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KEYWORDS="~amd64"
ROS_REPO_URI="https://github.com/ros-visualization/rqt_robot_plugins"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage of rqt plugins that are particularly used with robots during its operation"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rqt_moveit
	dev-ros/rqt_nav_view
	dev-ros/rqt_pose_view
	dev-ros/rqt_robot_dashboard
	dev-ros/rqt_robot_monitor
	dev-ros/rqt_robot_steering
	dev-ros/rqt_runtime_monitor
	dev-ros/rqt_rviz
	dev-ros/rqt_tf_tree
"
DEPEND="${RDEPEND}"
