# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Machine code generation for C++"
HOMEPAGE="https://asmjit.com/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/asmjit/asmjit"
else
	CommitId=f1096428b87e9d16305de16e91f2a7f52aef5a88
	SRC_URI="https://github.com/asmjit/${PN}/archive/${CommitId}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"/${PN}-${CommitId}
fi

LICENSE="ZLIB"
SLOT="0"
IUSE="test"

BDEPEND="test? ( dev-cpp/gtest )"
RESTRICT="!test? ( test )"

DOCS=( README.md CONTRIBUTING.md )

src_configure() {
	local mycmakeargs=(
		-DASMJIT_TEST=$(usex test)
	)
	cmake_src_configure
}
