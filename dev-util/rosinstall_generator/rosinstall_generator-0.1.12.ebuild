# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ros-infrastructure/rosinstall_generator"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Generates rosinstall files containing information about repositories with ROS packages/stacks"
HOMEPAGE="http://wiki.ros.org/rosinstall_generator"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/ros-infrastructure/rosinstall_generator/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-python/catkin_pkg-0.1.28[${PYTHON_USEDEP}]
	dev-python/rosdistro[${PYTHON_USEDEP}]
	dev-python/rospkg[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
