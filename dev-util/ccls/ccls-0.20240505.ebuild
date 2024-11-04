# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/MaskRay/${PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	LLVM_COMPAT=( {18..19} )
else
	LLVM_COMPAT=( {18..19} )
fi

inherit cmake llvm-r1 ${GIT_ECLASS}

DESCRIPTION="C/C++/ObjC language server"
HOMEPAGE="https://github.com/MaskRay/ccls"

if [[ ${PV} != *9999 ]] ; then
	SRC_URI="https://github.com/MaskRay/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="
	dev-libs/rapidjson
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}=
		sys-devel/llvm:${LLVM_SLOT}=
	')
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/ccls-0.20240202-gcc15-cstdint.patch
)

src_configure() {
	local mycmakeargs=(
		-DCCLS_VERSION=${PV}
		-DUSE_SYSTEM_RAPIDJSON=ON
		-DCLANG_LINK_CLANG_DYLIB=1
	)
	cmake_src_configure
}
