# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1

DESCRIPTION="Audio synchronization feature for vidify"
HOMEPAGE="https://vidify.org"
SRC_URI="https://github.com/vidify/old-audiosync/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libpulse
	media-video/ffmpeg[openssl]
	media-video/vidify[${PYTHON_USEDEP}]
	sci-libs/fftw
	debug? ( sci-visualization/gnuplot )
"
BDEPEND="test? ( dev-build/cmake )"

S="${WORKDIR}/old-audiosync-${PV}"

python_prepare_all() {
	if use debug; then
		sed -i -e "/defines.append(('DEBUG', '1'))/s/^# *//" setup.py || die
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	mkdir "test_build_${EPYTHON}" || die
	cd "test_build_${EPYTHON}" || die
	cmake .. -DBUILD_TESTING=YES || die
	emake
	emake test
	cd .. || die
}
