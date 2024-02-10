# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit python-single-r1 cmake

DESCRIPTION="C library for manipulating polynomials"
HOMEPAGE="https://github.com/SRI-CSL/libpoly/"
SRC_URI="https://github.com/SRI-CSL/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/gmp:=
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/sympy[${PYTHON_USEDEP}]')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/patchelf"

DOCS=( README.md examples )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i "s| -Werror||g"                          \
		"${S}"/src/CMakeLists.txt                   \
		"${S}"/test/polyxx/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLIBPOLY_BUILD_PYTHON_API=$(usex python)
		-DLIBPOLY_BUILD_STATIC=OFF
		-DLIBPOLY_BUILD_STATIC_PIC=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	mv "${D}"/usr/lib "${D}"/usr/$(get_libdir) || die

	if use python ; then
		local sitedir="${D}"/"$(python_get_sitedir)"
		local sopath="${BUILD_DIR}"/python/polypy.so

		patchelf --remove-rpath "${sopath}" || die

		mkdir -p "${sitedir}" || die
		cp "${sopath}" "${sitedir}" || die
	fi
}
