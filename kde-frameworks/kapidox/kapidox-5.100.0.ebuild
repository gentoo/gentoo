# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL="true"
DISTUTILS_USE_SETUPTOOLS="bdepend"
PYTHON_COMPAT=( python3_{8..11} )
inherit frameworks.kde.org distutils-r1

DESCRIPTION="Framework for building KDE API documentation in a standard format and style"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE=""

RDEPEND="
	app-doc/doxygen
	$(python_gen_cond_dep '
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	media-gfx/graphviz[python,${PYTHON_SINGLE_USEDEP}]
"
