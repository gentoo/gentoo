# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="A documentation generator for GObject-based libraries"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gi-docgen https://pypi.org/project/gi-docgen/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 GPL-3+ ) CC0-1.0 OFL-1.1 MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/markdown-3[${PYTHON_USEDEP}]
		>=dev-python/markupsafe-1[${PYTHON_USEDEP}]
		>=dev-python/pygments-2[${PYTHON_USEDEP}]
		>=dev-python/jinja-2[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
		>=dev-python/typogrify-2[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
