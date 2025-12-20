# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=Vulkan-Utility-Libraries
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"
inherit cmake-multilib dot-a python-any-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/${MY_PN}.git"
	inherit git-r3
else
	EGIT_COMMIT="vulkan-sdk-${PV}"
	SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}"/${MY_PN}-${EGIT_COMMIT}
fi

DESCRIPTION="Share code across various Vulkan repositories"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Utility-Libraries"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="~dev-util/vulkan-headers-${PV}
	test? (
		dev-cpp/gtest
		>=dev-cpp/magic_enum-0.9.7
	)"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.313.0-magic_enum-0.9.7.patch
)

src_configure() {
	lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

multilib_src_install_all() {
	einstalldocs
	strip-lto-bytecode
}
