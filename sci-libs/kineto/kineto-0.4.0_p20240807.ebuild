# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-any-r1 cmake prefix

CommitId=d9753139d181b9ff42872465aac0e5d3018be415

DESCRIPTION="part of the PyTorch Profiler"
HOMEPAGE="https://github.com/pytorch/kineto"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${CommitId}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-libs/libfmt
	dev-libs/dynolog
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
	${PYTHON_DEPS}
"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-gcc13.patch
)

src_prepare() {
	cd libkineto
	cmake_src_prepare
}

src_configure() {
	cd libkineto
	local mycmakeargs=(
		-DLIBKINETO_THIRDPARTY_DIR="${EPREFIX}"/usr/include/
		-DKINETO_BUILD_TESTS=OFF # tests require cuda toolkit
		-DCUDA_SOURCE_DIR=/opt/cuda
		-DLIBKINETO_NOXPUPTI=Yes
	)
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-0.4.0_p20231031-gentoo.patch)

	cmake_src_configure
}
