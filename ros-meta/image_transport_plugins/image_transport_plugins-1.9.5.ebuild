# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
ROS_REPO_URI="https://github.com/ros-perception/image_transport_plugins"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Plugins for publishing and subscribing topics in representations other than raw pixel data"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/compressed_depth_image_transport
	dev-ros/compressed_image_transport
	dev-ros/theora_image_transport
"
DEPEND="${RDEPEND}"
