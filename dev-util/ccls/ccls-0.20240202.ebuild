# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/MaskRay/${PN}"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	LLVM_MAX_SLOT=18
else
	LLVM_MAX_SLOT=18
fi

inherit cmake llvm ${GIT_ECLASS}

DESCRIPTION="C/C++/ObjC language server"
HOMEPAGE="https://github.com/MaskRay/ccls"

if [[ ${PV} != *9999 ]] ; then
	SRC_URI="https://github.com/MaskRay/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"

# We only depend on Clang because of a quirk in how dependencies work
# See comment in llvm.eclass docs
DEPEND="
	dev-libs/rapidjson
	<sys-devel/clang-$((${LLVM_MAX_SLOT} + 1)):=
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
