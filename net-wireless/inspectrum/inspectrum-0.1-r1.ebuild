# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils eutils

DESCRIPTION="a tool for analysing captured signals, primarily from software-defined radio receivers"
HOMEPAGE="https://github.com/miek/inspectrum"
if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/miek/inspectrum.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/miek/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="sci-libs/fftw:3.0=
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-cxxflags.patch
	cmake-utils_src_prepare
}
