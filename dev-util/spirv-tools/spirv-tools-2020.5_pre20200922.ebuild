# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=SPIRV-Tools
CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake-multilib python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	inherit git-r3
else
	EGIT_COMMIT="0a1fb588cd365f7737cb121fdd64553923e0cef6"
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}"/${MY_PN}-${EGIT_COMMIT}
fi

DESCRIPTION="Provides an API and commands for processing SPIR-V modules"
HOMEPAGE="https://github.com/KhronosGroup/SPIRV-Tools"

LICENSE="Apache-2.0"
SLOT="0"
# Tests fail upon finding symbols that do not match a regular expression
# in the generated library. Easily hit with non-standard compiler flags
RESTRICT="test"
COMMON_DEPEND=">=dev-util/spirv-headers-1.5.4"
DEPEND="${COMMON_DEPEND}"
RDEPEND=""
BDEPEND="${PYTHON_DEPS}
	${COMMON_DEPEND}"

PATCHES=(
        "${FILESDIR}"/"${PN}"-2020.5-Fix-build.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		"-DSPIRV-Headers_SOURCE_DIR=/usr/"
		"-DSPIRV_WERROR=OFF"
	)

	cmake_src_configure
}
