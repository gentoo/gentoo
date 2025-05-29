# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Detect confusable usage of unicode homoglyphs, prevent homograph attacks"
HOMEPAGE="
	https://git.sr.ht/~valhalla/confusable_homoglyphs/
	https://pypi.org/project/confusable-homoglyphs/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

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
