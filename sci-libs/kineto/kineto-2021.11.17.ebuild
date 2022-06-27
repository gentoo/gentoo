# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-any-r1 cmake

CommitId=659a7f99ee737103273ef60551bfe1611c2d2cba

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
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( dev-cpp/gtest )
	${PYTHON_DEPS}
"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${CommitId}

src_prepare() {
	eapply "${FILESDIR}"/${P}-gentoo.patch
	cd libkineto
	cmake_src_prepare
}

src_configure() {
	cd libkineto
	cmake_src_configure
}
