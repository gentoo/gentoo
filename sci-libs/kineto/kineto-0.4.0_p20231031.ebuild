# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit python-any-r1 cmake

CommitId=a30ca3f9509c2cfd28561abbca51328f0bdf9014

DESCRIPTION="part of the PyTorch Profiler"
HOMEPAGE="https://github.com/pytorch/kineto"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

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
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${PN}-0.4.0-gcc13.patch
)

S="${WORKDIR}"/${PN}-${CommitId}

src_prepare() {
	cd libkineto
	cmake_src_prepare
}

src_configure() {
	cd libkineto
	local mycmakeargs=(
		-DLIBKINETO_THIRDPARTY_DIR=/usr/include/
	)

	cmake_src_configure
}
