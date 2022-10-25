# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros/gencpp"
KEYWORDS="~amd64 ~arm"

inherit ros-catkin

DESCRIPTION="ROS C++ message definition and serialization generators"
HOMEPAGE="https://wiki.ros.org/gencpp"
LICENSE="BSD"
SLOT="0/${PV}"
IUSE=""

RDEPEND="dev-ros/genmsg[${PYTHON_SINGLE_USEDEP}]"
DEPEND="${RDEPEND}"
