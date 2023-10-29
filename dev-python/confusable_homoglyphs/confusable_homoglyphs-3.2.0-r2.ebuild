# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Detect confusable usage of unicode homoglyphs, prevent homograph attacks"
HOMEPAGE="
	https://github.com/vhf/confusable_homoglyphs/
	https://pypi.org/project/confusable_homoglyphs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# removed outdated bundled version (for py3.12 compat)
	rm versioneer.py || die
	distutils-r1_src_prepare
}
