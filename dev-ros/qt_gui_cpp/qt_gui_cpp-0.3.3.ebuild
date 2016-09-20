# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/qt_gui_core"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python2_7 )
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="Foundation for C++-bindings for dev-ros/qt_gui and creates bindings for every generator available"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	>=dev-ros/pluginlib-1.9.23
	>=dev-ros/qt_gui-0.3.0[${PYTHON_USEDEP}]
	dev-libs/tinyxml
	>=dev-ros/python_qt_binding-0.3.0[${PYTHON_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/libdir.patch"
)
