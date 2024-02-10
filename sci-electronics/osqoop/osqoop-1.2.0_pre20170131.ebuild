# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=b5bd459dd5c2a180a9a3e5a706ed5039159d7286
inherit cmake

DESCRIPTION="Multi-platform open source software oscilloscope based on Qt"
HOMEPAGE="https://github.com/stephanemagnenat/osqoop https://github.com/sandsmark/osqoop"
# sandsmark/osqoop: PR-branch on top of last commit in stephanemagnenat/osqoop (17-01-31)
SRC_URI="https://github.com/sandsmark/osqoop/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	sci-libs/fftw:3.0
	virtual/libusb:0
	x11-libs/libXtst"
DEPEND="${RDEPEND}"

# downstream fix for BUILD_SHARED_LIBS=ON default
PATCHES=(
	"${FILESDIR}"/${P}-cmake-add_library-static.patch
)
