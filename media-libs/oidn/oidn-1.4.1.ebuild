# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit cmake python-single-r1

DESCRIPTION="Intel(R) Open Image Denoise library"
HOMEPAGE="http://www.openimagedenoise.org/"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenImageDenoise/oidn.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/OpenImageDenoise/${PN}/releases/download/v${PV}/${P}.src.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/tbb
	dev-lang/ispc"
BDEPEND="
	${RDEPEND}
	dev-util/cmake"

CMAKE_BUILD_TYPE=Release

pkg_setup() {
	python-single-r1_pkg_setup
}
