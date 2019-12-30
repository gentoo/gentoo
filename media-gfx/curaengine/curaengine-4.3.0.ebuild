# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils toolchain-funcs

MY_PN="CuraEngine"

DESCRIPTION="A 3D model slicing engine for 3D printing"
HOMEPAGE="https://github.com/Ultimaker/CuraEngine"
SRC_URI="https://github.com/Ultimaker/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="|| ( sys-devel/gcc sys-devel/clang )
	doc? ( app-doc/doxygen )"
RDEPEND="${PYTHON_DEPS}
	~dev-libs/libarcus-${PV}:*
	dev-libs/protobuf
	dev-libs/stb"
DEPEND="${RDEPEND}"

DOCS=( README.md )

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	local mycmakeargs=( "-DBUILD_TESTS=$(usex test ON OFF)" )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
	if use doc; then
		doxygen || die
		mv docs/html . || die
		find html -name '*.md5' -or -name '*.map' -delete || die
		DOCS+=( html )
	fi
}
