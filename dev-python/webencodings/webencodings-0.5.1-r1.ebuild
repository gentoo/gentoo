# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

DESCRIPTION="Character encoding aliases for legacy web content"
HOMEPAGE="https://github.com/SimonSapin/python-webencodings https://pypi.org/project/webencodings/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all(){
	cat >> setup.cfg <<- EOF
	[tool:pytest]
	python_files=test*.py
	EOF
	distutils-r1_python_prepare_all
}
