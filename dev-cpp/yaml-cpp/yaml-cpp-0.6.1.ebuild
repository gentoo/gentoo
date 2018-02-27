# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="YAML parser and emitter in C++"
HOMEPAGE="https://github.com/jbeder/yaml-cpp"
SRC_URI="https://github.com/jbeder/${PN}/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/06"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

# (sic!)
S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}/${P}-cve-2017-5950.patch"
	"${FILESDIR}/${P}-externalize-googletest-project.patch" )

src_prepare() {
	sed -i \
		-e 's:INCLUDE_INSTALL_ROOT_DIR:INCLUDE_INSTALL_DIR:g' \
		yaml-cpp.pc.cmake || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DYAML_CPP_BUILD_TOOLS=OFF # Don't have install rule
		-DYAML_CPP_BUILD_TESTS=$(usex test)
	)
	cmake-multilib_src_configure
}
