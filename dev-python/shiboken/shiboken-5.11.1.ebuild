# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils llvm python-r1

DESCRIPTION="Tool for creating Python bindings for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV}-src/pyside-setup-everywhere-src-${PV}.tar.xz"

# The "sources/shiboken2/libshiboken" directory is triple-licensed under the GPL
# v2, v3+, and LGPL v3. All remaining files are licensed under the GPL v3 with
# version 1.0 of a Qt-specific exception enabling shiboken2 output to be
# arbitrarily relicensed. (TODO)
LICENSE="|| ( GPL-2 GPL-3+ LGPL-3 ) GPL-3"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="numpy test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	dev-libs/libxml2
	dev-libs/libxslt
	dev-qt/qtcore:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	sys-devel/clang:="

RDEPEND="${DEPEND}"

S="${WORKDIR}/pyside-setup-everywhere-src-${PV}/sources/shiboken2"

DOCS=( AUTHORS )

PATCHES=(
	"${FILESDIR}"/${PN}-5.11.1-fix-clang-include-path.patch
)

# Ensure the path returned by get_llvm_prefix() contains clang as well.
llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	#FIXME: File an upstream issue requesting a sane way to disable NumPy support.
	if ! use numpy; then
		sed -i -e '/print(os\.path\.realpath(numpy))/d' libshiboken/CMakeLists.txt || die
	fi

	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	eapply "${FILESDIR}"/${PN}-5.11.1-fix-warnings.patch

	cmake-utils_src_prepare
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DBUILD_TESTS=$(usex test)
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}2{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}
