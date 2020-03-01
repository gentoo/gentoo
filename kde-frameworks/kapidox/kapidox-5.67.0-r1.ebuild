# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_SINGLE_IMPL="true"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit cmake kde.org distutils-r1

DESCRIPTION="Framework for building KDE API documentation in a standard format and style"
LICENSE="BSD-2"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"
IUSE=""

RDEPEND="
	app-doc/doxygen
	$(python_gen_cond_dep '
		dev-python/jinja[${PYTHON_MULTI_USEDEP}]
		dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]
	')
	media-gfx/graphviz[python,${PYTHON_SINGLE_USEDEP}]
"

pkg_setup() {
	python-single-r1_pkg_setup
}
