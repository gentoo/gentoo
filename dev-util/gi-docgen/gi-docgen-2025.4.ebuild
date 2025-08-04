# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A documentation generator for GObject-based libraries"
HOMEPAGE="
	https://gitlab.gnome.org/GNOME/gi-docgen
	https://pypi.org/project/gi-docgen/
"

SRC_URI="https://download.gnome.org/sources/${PN}/$(ver_cut 1)/${P}.tar.xz"
LICENSE="|| ( Apache-2.0 GPL-3+ ) CC0-1.0 OFL-1.1 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/markdown-3.2[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-1[${PYTHON_USEDEP}]
		>=dev-python/pygments-2[${PYTHON_USEDEP}]
		>=dev-python/jinja2-2[${PYTHON_USEDEP}]
		>=dev-python/typogrify-2[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest
