# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/rosserial"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Metapackage for core of rosserial"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/rosserial_arduino
	dev-ros/rosserial_client
	dev-ros/rosserial_embeddedlinux
	dev-ros/rosserial_msgs
	dev-ros/rosserial_python
	dev-ros/rosserial_server
	dev-ros/rosserial_tivac
	dev-ros/rosserial_windows
	dev-ros/rosserial_xbee
"
DEPEND="${RDEPEND}"
