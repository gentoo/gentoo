# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Tool for analysing captured signals from software-defined radio receivers"
HOMEPAGE="https://github.com/miek/inspectrum"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/miek/inspectrum.git"
	inherit git-r3
else
	SRC_URI="https://github.com/miek/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	net-libs/liquid-dsp
	sci-libs/fftw:3.0="
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"
BDEPEND="virtual/pkgconfig"
