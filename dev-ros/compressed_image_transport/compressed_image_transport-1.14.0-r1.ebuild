# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
ROS_REPO_URI="https://github.com/ros-perception/image_transport_plugins"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Plugin for transparently sending images encoded as JPEG or PNG"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/cv_bridge
	dev-ros/dynamic_reconfigure[${PYTHON_SINGLE_USEDEP}]
	dev-ros/image_transport
	media-libs/opencv:=
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/ocv_leak.patch" )
