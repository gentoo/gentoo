# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/qt_gui_core"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Main to start an instance of the integrated graphical user interface provided by qt_gui"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-ros/qt_gui-0.3.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
