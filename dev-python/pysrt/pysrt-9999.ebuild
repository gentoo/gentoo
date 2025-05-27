# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python library used to edit or create SubRip files"
HOMEPAGE="
	https://github.com/byroot/pysrt/
	https://pypi.org/project/pysrt/
"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/byroot/pysrt.git"
else
	inherit pypi
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
