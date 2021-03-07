# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-visualization/rqt"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Instance of the ROS integrated graphical user interface provided by qt_gui"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/qt_gui-0.3.0[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:="
DEPEND="${RDEPEND}"
PATCHES=( "${FILESDIR}/gentoo.patch" )
