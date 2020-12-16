# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 virtualx

DESCRIPTION="Extract code blocks from markdown"
HOMEPAGE="https://github.com/nschloe/exdown"
SRC_URI="https://github.com/nschloe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$( python_gen_cond_dep \
		'dev-python/importlib_metadata[${PYTHON_USEDEP}]' python3_7 )
"

BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# setup.py was removed in commit ddb8a613bbc8ba7d079c1b7abbca5ce2d53ef9d0
	# for some reason, DISTUTULS_USE_SETUPTOOLS="pyproject.toml" is not working
	# it complains about file not found, setup.cfg does exist
	cat > setup.py <<EOF || die
from setuptools import setup

if __name__ == "__main__":
	setup()
EOF

	distutils-r1_python_prepare_all
}
