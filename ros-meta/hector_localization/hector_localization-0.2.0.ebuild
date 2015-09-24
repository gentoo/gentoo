# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/tu-darmstadt-ros-pkg/hector_localization"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Collection of packages, that provide the full 6DOF pose of a robot or platform"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/hector_pose_estimation
	dev-ros/hector_pose_estimation_core
	dev-ros/message_to_tf
"
DEPEND="${RDEPEND}"
