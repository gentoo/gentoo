# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

DESCRIPTION="Pure python spell checker based on work by Peter Norvig"
HOMEPAGE="
	https://github.com/barrust/pyspellchecker
	https://pypi.org/project/pyspellchecker/
"
SRC_URI="https://github.com/barrust/pyspellchecker/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests unittest

python_test() {
	eunittest -p '*_test.py'
}
