# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-r1

DESCRIPTION="Python wrapper for libcangjie"
HOMEPAGE="https://cangjie.pages.freedesktop.org/projects/pycangjie/"
SRC_URI="https://gitlab.freedesktop.org/cangjie/pycangjie/-/jobs/66354698/artifacts/raw/builddir/meson-dist/py${P}.tar.xz"
S="${WORKDIR}"/py${P}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=app-i18n/libcangjie-1.4.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-1.3.2
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig
"

src_configure() {
	python_foreach_impl run_in_build_dir meson_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir meson_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir meson_src_test
}

src_install() {
	python_install() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl run_in_build_dir python_install
	einstalldocs
}
