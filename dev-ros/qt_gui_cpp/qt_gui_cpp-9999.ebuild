# Copyright 1999-2014 Gentoo Foundation
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
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	>=dev-ros/pluginlib-1.9.23
	>=dev-ros/qt_gui-0.2.18[${PYTHON_USEDEP}]
	dev-libs/tinyxml
	dev-ros/python_qt_binding[${PYTHON_USEDEP}]
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/libdir.patch"
)
