# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros/nodelet_core"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Common nodelet tools such as a mux, demux and throttle"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=[threads]
	dev-ros/dynamic_reconfigure[${PYTHON_USEDEP}]
	dev-ros/message_filters
	dev-ros/nodelet
	dev-ros/pluginlib
	dev-ros/roscpp
"
DEPEND="${RDEPEND}"
