# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Modern C++ Parallel Task Programming"
HOMEPAGE="https://cpp-taskflow.github.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=""
DEPEND=""

S="${WORKDIR}/taskflow-${PV}"

PATCHES=(
)

HTML_DOCS=( docs/. )

src_prepare() {
	default

	# fix library directoy
	sed -i "s#/lib#/$(get_libdir)#g" CMakeLists.txt || die "sed failed"

	cmake-utils_src_prepare
}

src_configure() {
	# FIXME: enable CUDA and TESTS via use flag
	local mycmakeargs=(
		-DTF_BUILD_CUDA=OFF
		-DTF_BUILD_TESTS=OFF
		-DTF_BUILD_EXAMPLES=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if $(use doc); then
		einstalldocs
	fi
}
