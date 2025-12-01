# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tool for analysing captured signals from software-defined radio receivers"
HOMEPAGE="https://github.com/miek/inspectrum"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/miek/inspectrum.git"
	inherit git-r3
else
	# snapshot for Qt6 support
	COMMIT="82f5779ee3b82fc2b4d6d1360d9106392a71d4ab"
	SRC_URI="https://github.com/miek/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-qt/qtbase:6[concurrent,gui,widgets]
	net-libs/liquid-dsp
	sci-libs/fftw:3.0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	sed -i -e "s/3.5/3.10/" CMakeLists.txt || die
	cmake_src_prepare
}
