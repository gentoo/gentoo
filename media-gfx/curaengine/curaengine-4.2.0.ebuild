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

BDEPEND="|| ( <sys-devel/gcc-9 <sys-devel/clang-8 )
	doc? ( app-doc/doxygen )"
RDEPEND="${PYTHON_DEPS}
	~dev-libs/libarcus-${PV}:*
	dev-libs/protobuf
	dev-libs/stb"
DEPEND="${RDEPEND}"

DOCS=( README.md )

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_pretend() {
	if [[ $(tc-getCC) == clang ]] && [[ $(clang-major-version) -ge 8 ]]; then
		eerror "Compilation with sys-devel/clang-8 or newer is not supported"
		eerror "See https://github.com/Ultimaker/CuraEngine/issues/984 for more information"
		eerror ""
		die "Incompatible clang version found"
	elif [[ $(gcc-major-version) -ge 9 ]]; then
		eerror "Compilation with sys-devel/gcc-9 or newer is not supported"
		eerror "See https://github.com/Ultimaker/CuraEngine/issues/984 for more information"
		eerror ""
		die "Incompatible gcc version found"
	fi
}

src_configure() {
	local mycmakeargs=( "-DBUILD_TESTS=$(usex test ON OFF)" )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
	if use doc; then
		doxygen
		mv docs/html . || die
		find html -name '*.md5' -or -name '*.map' -delete || die
		DOCS+=( html )
	fi
}
