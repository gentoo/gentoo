# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Converts SVG files to PDFs or reportlab graphics"
HOMEPAGE="
	https://github.com/sarnold/svg2rlg/
	https://pypi.org/project/svg2rlg/
"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/svg2rlg.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="
		https://github.com/sarnold/svg2rlg/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/reportlab[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	epytest test_svg2rlg.py
}
