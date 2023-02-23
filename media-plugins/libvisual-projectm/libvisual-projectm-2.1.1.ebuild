# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P=frontend-libvisual-plug-in-${PV}
DESCRIPTION="A libvisual graphical music visualization plugin similar to milkdrop"
HOMEPAGE="https://github.com/projectM-visualizer/frontend-libvisual-plug-in"
SRC_URI="https://github.com/projectM-visualizer/frontend-libvisual-plug-in/archive/refs/tags/v${PV}.tar.gz -> ${P}-gh.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-libs/libprojectm-3.1.12:0=
	media-libs/libsdl
	=media-libs/libvisual-0.4*
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
