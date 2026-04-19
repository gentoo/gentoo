# Copyright 2014-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_OPTIONAL="1"
DISTUTILS_EXT=1

inherit cmake distutils-r1 git-r3

DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge"
HOMEPAGE="https://github.com/s-yata/marisa-trie"
EGIT_REPO_URI="https://github.com/s-yata/marisa-trie"

LICENSE="|| ( BSD-2 LGPL-2.1+ )"
SLOT="0"
IUSE="python tools"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="python? (
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		dev-lang/swig
	)"
DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/marisa-0.3.1-install-all-configs.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -e "s:^\([[:space:]]*\)libraries=:\1include_dirs=[\"${S}/include\"],\n\1library_dirs=[\"${BUILD_DIR}\"],\n&:" \
		-e "s:setup(name = \"marisa\":setup(name = \"marisa\", version = \"${PV}\":" \
		-i bindings/python/setup.py || die

	if use python; then
		pushd bindings/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-DENABLE_TOOLS=$(usex tools)
		-DBUILD_TESTING=OFF
	)
	cmake_src_configure

	if use python; then
		pushd bindings/python > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	cmake_src_compile

	if use python; then
		emake -C bindings swig-python
		pushd bindings/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_install() {
	cmake_src_install

	(
		docinto html
		dodoc docs/*
	)

	if use python; then
		pushd bindings/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi
}
