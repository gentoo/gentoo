# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/ros-drivers/audio_common"
KEYWORDS="~amd64 ~arm"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Common code for working with audio in ROS"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-ros/audio_capture
	dev-ros/audio_common_msgs
	dev-ros/audio_play
"
#	dev-ros/sound_play
# https://bugs.gentoo.org/612980#c14

DEPEND="${RDEPEND}"
