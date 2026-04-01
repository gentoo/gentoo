# Copyright 2014-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_OPTIONAL="1"
DISTUTILS_EXT=1

inherit cmake distutils-r1

DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge"
HOMEPAGE="https://github.com/s-yata/marisa-trie"
SRC_URI="https://github.com/s-yata/marisa-trie/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/marisa-trie-${PV}"

LICENSE="|| ( BSD-2 LGPL-2.1+ )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
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
	"${FILESDIR}/${P}-install-all-configs.patch"
	"${FILESDIR}/${P}-fix-swig-bindings.patch"
)

src_prepare() {
	cmake_src_prepare

	sed -e "s:^\([[:space:]]*\)libraries=:\1include_dirs=[\"../../include\"],\n\1library_dirs=[\"../../lib/marisa\"],\n&:" \
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
