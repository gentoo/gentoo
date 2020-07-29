# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_transport_plugins"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Plugins for creating topics in representations other than raw pixel data"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/compressed_depth_image_transport
	dev-ros/compressed_image_transport
	dev-ros/theora_image_transport
"
DEPEND="${RDEPEND}"
