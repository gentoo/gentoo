# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
ROS_REPO_URI="https://github.com/pr2/pr2_common"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}
PYTHON_COMPAT=( python2_7 )

inherit ros-catkin

DESCRIPTION="Description (mechanical, kinematic, visual,  etc.) of the PR2 robot"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-ros/xacro[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-ros/convex_decomposition
	dev-ros/ivcon
	test? ( dev-libs/urdfdom dev-cpp/gtest )"
PATCHES=( "${FILESDIR}/tests.patch" )
