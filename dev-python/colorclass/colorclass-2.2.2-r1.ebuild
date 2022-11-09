# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Colorful worry-free console applications for multiple platforms"
HOMEPAGE="
	https://pypi.org/project/colorclass/
	https://github.com/matthewdeanmartin/colorclass/
"
SRC_URI="
	https://github.com/matthewdeanmartin/colorclass/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

BDEPEND="
	test? (
		dev-python/docopt[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -e '/requires/s:poetry:&-core:' \
		-e '/backend/s:poetry:&.core:' \
		-i pyproject.toml || die

	distutils-r1_src_prepare
}
