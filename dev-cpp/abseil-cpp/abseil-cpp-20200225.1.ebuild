# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
HOMEPAGE="https://abseil.io"
SRC_URI="https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	cmake_src_prepare

	# un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die

		# now generate cmake files
		absl/copts/generate_copts.py || die
}

src_configure() {
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
	)
	cmake_src_configure
}
