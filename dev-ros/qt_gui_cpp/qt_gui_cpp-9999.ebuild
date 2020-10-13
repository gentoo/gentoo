# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ROS_REPO_URI="https://github.com/ros-visualization/qt_gui_core"
KEYWORDS="~amd64"
ROS_SUBDIR=${PN}

inherit ros-catkin

DESCRIPTION="C++-bindings for qt_gui and creates bindings for every generator available"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	>=dev-ros/pluginlib-1.9.23
		dev-libs/tinyxml2:=
	>=dev-ros/qt_gui-0.3.0[${PYTHON_SINGLE_USEDEP}]
	dev-libs/tinyxml
	>=dev-ros/python_qt_binding-0.3.0[${PYTHON_SINGLE_USEDEP}]
	dev-libs/boost:=
	dev-libs/console_bridge:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}/libdir.patch"
	"${FILESDIR}/rpaths.patch"
)

# FIXME: fails to build with ninja
CMAKE_MAKEFILE_GENERATOR=emake
