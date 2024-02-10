# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python library that performs advanced searches in strings"
HOMEPAGE="
	https://github.com/Toilal/rebulk/
	https://pypi.org/project/rebulk/
"
SRC_URI="
	https://github.com/Toilal/rebulk/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

distutils_enable_tests pytest

python_prepare_all() {
	# Remove base64-encoded zip archive with pytest.
	rm runtests.py || die

	distutils-r1_python_prepare_all
}
