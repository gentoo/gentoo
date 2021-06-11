# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-single-r1 udev

DESCRIPTION="A C++ library for interfacing with the ADALM2000"
HOMEPAGE="https://github.com/analogdevicesinc/libm2k"
if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/analogdevicesinc/libm2k.git"
	inherit git-r3
else
	COMMIT="f98dfa42134d2dff458c7832842d1f51c3131aa4"
	SRC_URI="https://github.com/analogdevicesinc/libm2k/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="GPL-3+"
SLOT="0"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	net-libs/libiio
	"
DEPEND="${RDEPEND}
	dev-lang/swig
"

src_configure() {
	mycmakeargs=(
		-DUDEV_RULES_PATH="$(get_udevdir)"/rules.d
		-DCMAKE_SKIP_BUILD_RPATH=TRUE
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	#this seems to not compile things
	python_optimize
}
