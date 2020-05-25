# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
inherit cmake-multilib

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
SRC_URI="https://github.com/jbeder/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/0.6"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# test breaks build
# RESTRICT="!test? ( test )"
RESTRICT+="test"

DEPEND="test? ( dev-cpp/gtest )"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/${P}-abi-breakage.patch"
	"${FILESDIR}/${P}-CVE-2017-11692.patch"
)

src_prepare() {
	sed -i \
		-e 's:INCLUDE_INSTALL_ROOT_DIR:INCLUDE_INSTALL_DIR:g' \
		yaml-cpp.pc.cmake || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DYAML_BUILD_SHARED_LIBS=ON
		-DYAML_CPP_BUILD_TOOLS=OFF # Don't have install rule
		-DYAML_CPP_BUILD_TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}
