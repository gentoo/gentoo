# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt Social Network Visualizer"
HOMEPAGE="https://socnetv.org/"
SRC_URI="https://github.com/socnetv/app/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/app-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,network,opengl,ssl,widgets,xml]
	dev-qt/qtcharts:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
# 0 finished for now
# BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2-docdir.patch
)
