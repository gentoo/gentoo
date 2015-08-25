# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils
inherit git-r3

DESCRIPTION="a tool for analysing captured signals, primarily from software-defined radio receivers"
HOMEPAGE="https://github.com/miek/inspectrum"
SRC_URI=""
EGIT_REPO_URI="https://github.com/miek/inspectrum.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sci-libs/fftw:3.0=
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_install() {
	dobin "${BUILD_DIR}"/inspectrum
}
